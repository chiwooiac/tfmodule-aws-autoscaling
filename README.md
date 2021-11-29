# tfmodule-aws-autoscaling

EC2 Auto-Scaling 그룹 을 생성하는 테라폼 모듈 입니다.

## Example

```
data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = ["melonops*"]
  }
}

# ASG VPC Subnet ids 참조
data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }

  filter {
    name   = "tag:Name"
    values = ["melonops-an2p-web*"]
  }
}

# Launch Template 참조
data "aws_launch_template" "my_web" {
  name = "my_web"
}

module "my_asg" {
  source = "../../"

  context              = var.context
  name                 = "my-web"
  launch_template_name = data.aws_launch_template.my_web.name
  launch_template_version = var.lt_version == null ? data.aws_launch_template.my_web.default_version : var.lt_version
  vpc_zone_identifier  = toset(data.aws_subnets.this.ids)
  desired_capacity     = 1
  min_size             = 1
  max_size             = 8
} 
```

## Input Variables

| Name | Description | Type | Example | Required |
|------|-------------|------|---------|:--------:|
| create_asg | autoscaling group 생성 여부를 설정 합니다. | bool | true | Yes |
| name | autoscaling group 이름을 설정 합니다. EC2 Instance 이름을 나타냅니다. | string | "myweb" | Yes |
| launch_template_name | autoscaling group 이 참조할 launch template 이름을 설정 합니다. | string | "myweb_lt" | Yes |
| launch_template_version | autoscaling group 이 참조할 launch template 버전을 설정 합니다. | string | - | No |
| vpc_zone_identifier | autoscaling group 이 참조할 가용 영역으로 서브넷 아이이디를 설정 합니다. | list(string) | ["subnet-060ad7aa081b4e970", "subnet-05ad20a498f6231cd"] | Yes |
| min_size |  최소 scaling 크기 입니다. | number | 1 | Yes |
| max_size |  최대 scaling 크기 입니다. | number | 10 | Yes |
| desired_capacity | autoscaling group 이 최초 생성 해야 할 인스턴스 갯수 입니다. | number | 0 | Yes |
| capacity_rebalance | 용량 재산정 및 평준화 여부를 설정 합니다. | bool | - | No |
| default_cooldown | autoscaling group 변경 적용이 완료된 이후 다른 조정 활동을 시작할 수 있을 때까지 걸리는 대기 시간(초) 입니다. | number | - | No |
| protect_from_scale_in | 인스턴스 종료 보호 설정을 허용합니다. scale-in 이벤트 중 인스턴스 종료를 위해서 이 설정은 하지 않습니다. | bool | - | No |
| classic_lb_arns | 클래식 로드밸런서 ARN 입니다. | list(string) | ["arn:aws:elasticloadbalancing:ap-northeast-2:111111:loadbalancer/330efb996f021ec"] | No |
| target_group_arns | 로드 밸런서가 ALB 또는 NLB 인 경우 여기에 연결된 Target Group ARN 입니다. | list(string) | ["arn:aws:elasticloadbalancing:ap-northeast-2:11111111:targetgroup/4a7b25f005f985"] | No |
| placement_group | 인스턴스 배치 그룹 이름 입니다. | string | - | No |
| health_check_type | 인스턴스 Health check 유형 입니다. "EC2" 또는 "ELB" 값이 유효 합니다.| string | - | No |
| health_check_grace_period | 인스턴스가 서비스를 시작한 이후 상태를 확인하기 전의 시간(초) 입니다. | number | -  | No |
| force_delete | Auto Scaling Group이 적용되고 있는 중 이라도 강제 삭제가 가능한지 여부 입니다. | bool | -  | No |
| termination_policies | Auto Scaling Group의 인스턴스를 종료하는 방법을 결정하는 정책 목록입니다. 허용되는 값은 'OldestInstance', 'NewestInstance', 'OldestLaunchConfiguration', 'ClosestToNextInstanceHour', 'OldestLaunchTemplate', 'AllocationStrategy', 'Default'입니다. | list(string) | ["OldestLaunchConfiguration","OldestLaunchTemplate"]  | No |
| suspended_processes | Auto Scaling Group에 대해 일시 중단할 프로세스 목록입니다. 허용되는 값은 'Launch', 'Terminate', 'HealthCheck', 'ReplaceUnhealthy', 'AZRebalance', 'AlarmNotification', 'ScheduledActions', 'AddToLoadBalancer'입니다. '실행' 또는 '종료' 프로세스 유형을 일시 중단하면 Auto Scaling 그룹이 제대로 작동하지 않을 수 있습니다.| list(string) |  ["AZRebalance"]  | No |
| max_instance_lifetime | 인스턴스가 서비스될 수 있는 최대 시간(초) 값은 0과 같거나 86400~31536000초 사이여야 합니다. | number | - | No |
| enabled_metrics | 수집할 메트릭 입니다. 유효한 값은 `GroupDesiredCapacity`, `GroupInServiceCapacity`, `GroupPendingCapacity`, `GroupMinSize`, `GroupMaxSize`, `GroupInServiceInstances`, `GroupPendingInstances`, `GroupStandbyInstances`, `GroupStandbyCapacity`, `GroupTerminatingCapacity`, `GroupTerminatingInstances` 입니다. | list(string) | ["GroupDesiredCapacity", "GroupMinSize", "GroupMaxSize"] | No |
| metrics_granularity | 메트릭 수집 주기를 설정 합니다. 유효한 값은 `1Minute` 만 가능합니다. | string | - | No |
| service_linked_role_arn | Auto Scaling 그룹이 다른 AWS 서비스를 호출하는 데 사용될 서비스 연결 역할의 ARN 입니다. (예: CodeDeploy 호출 등) | string | - | No |
| create_service_linked_role | 서비스 연결 역할을 생성할 지 여부를 설정 합니다. | bool | false | No |
| initial_lifecycle_hooks | 인스턴스가 시작되기 전에 Auto Scaling 그룹에 연결할 하나 이상의 Lifecycle Hook 입니다. 주의사항으로, 새로운 Auto Scaling 그룹을 생성할 때만 동작합니다. 점에 유의하십시오. | list(map(string)) | <pre>[<br>  {<br>    name = "ExampleStartupLifeCycleHook"<br>    default_result = "CONTINUE"<br>    heartbeat_timeout = 60<br>    lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"<br>    notification_metadata = jsonencode({ "hello" = "world" })<br>  },<br>  {<br>    name = "ExampleTerminationLifeCycleHook"<br>    default_result = "CONTINUE"<br>    heartbeat_timeout = 180<br>    lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"<br>    notification_metadata = jsonencode({ "goodbye" = "world" })<br>  }<br>]</pre> | No |
| instance_refresh | Auto Scaling Group이 업데이트될 때 인스턴스를 새로고침 합니다. | any | <pre>{<br>  strategy = "Rolling"<br>  preferences = {<br>    min_healthy_percentage = 50<br>  }<br>}</pre> | No |
| delete_timeout | Auto Scaling Group 삭제시 타임 아웃 시간(초)를 설정 합니다. | string | - | No |
| tags | key, value, propagate_at_launch 속성으로 정의되는 태그를 설정 합니다. | string | <pre>[<br>  {<br>    key = "Hello"<br>    value = "World"<br>    propagate_at_launch = true<br>  },<br>]</pre> | No |
| warm_pool | Auto Scaling 그룹에 Warm Pool을 추가합니다. | any | <pre>{<br>  pool_state = "Stopped"<br>  min_size = 3<br>  max_group_prepared_capacity = 6<br>}</pre> | No |
| create_schedule | Auto Scaling 그룹의 정기 작업(Cron Job) 설정 여부입니다. | bool | false | No |
| schedules | Auto Scaling 그룹의 자동 조정 중 정기 작업(Cron Job)을 설정 합니다. | map(any) | {<br>  night = {<br>    min_size = 0<br>    max_size = 0<br>    desired_capacity = 0<br>    recurrence = "0 18 * * 1-5" # Mon-Fri in the evening<br>    time_zone = "Asia/Seoul"<br>  }<br>  morning = {<br>    min_size = 0<br>    max_size = 1<br>    desired_capacity = 1<br>    recurrence = "0 7 * * 1-5" # Mon-Fri in the morning<br>  }<br>  future = {<br>    min_size = 0<br>    max_size = 0<br>    desired_capacity = 0<br>    start_time = "2031-12-31T10:00:00Z" # Should be in the future<br>    end_time = "2032-01-01T16:00:00Z"<br>  }<br>} | No |

### Variables Reference

- [service_linked_role](https://docs.aws.amazon.com/ko_kr/autoscaling/ec2/userguide/autoscaling-service-linked-role.html) Auto Scaling 서비스 연결 역할 참고
- [initial_lifecycle_hooks](https://docs.aws.amazon.com/ko_kr/autoscaling/ec2/userguide/lifecycle-hooks.html) Auto Scaling Lifecycle Hook 참고
- [warm_pool](https://docs.aws.amazon.com/ko_kr/autoscaling/ec2/userguide/ec2-auto-scaling-warm-pools.html) Auto Scaling Warm Pool 참고

## Output

| Name | Description | Example |
|------|-------------|------|
| autoscaling_group_id | Autoscaling 그룹 아이디 입니다. |"my-web-asg" |
| autoscaling_group_name | Autoscaling 그룹 이름 입니다. | "my-web-asg" |
| autoscaling_group_arn | Autoscaling 그룹 ARN 입니다. | "arn:aws:autoscaling:..."  |
| autoscaling_group_min_size | Autoscaling min size 입니다. | 1 |
| autoscaling_group_max_size | Autoscaling max size 입니다. | 4 |
| autoscaling_group_desired_capacity | Autoscaling 시작 인스턴스 갯수 입니다. | 0 |
| service_linked_role_arn | Auto Scaling 그룹이 다른 AWS 서비스를 호출하는 데 사용될 서비스 연결 역할의 ARN 입니다.  | "arn:aws:iam::..." |
| autoscaling_group_default_cooldown | Autoscaling cooldown 시간 입니다. | 300 |
| autoscaling_group_health_check_grace_period | Autoscaling 그룹 서비스 인스턴스 Health 체크 시간 입니다. | 300 |
| autoscaling_group_health_check_type | Autoscaling 그룹 서비스 인스턴스 Health 유형 입니다. | "EC2" |
| autoscaling_group_vpc_zone_identifier | Autoscaling 그룹의 availability subnet 아이디 입니다. | ["subnet-05ad20a498f6231cd","subnet-06067b000d3c1bd9e",]  |
| autoscaling_group_availability_zones | Autoscaling 그룹의 availability zones 아이디 입니다. | ["ap-northeast-2a","ap-northeast-2c",]  |
| autoscaling_group_load_balancers | Autoscaling 그룹의 클래식 로드밸런서 이름 입니다. | - |
| autoscaling_group_target_group_arns | Autoscaling 그룹의 타겟 그룹 ARN 입니다. | "arn:aws:elasticloadbalancing:..."  |
| autoscaling_schedule_arns | Autoscaling 그룹의 스케줄러 ARN 입니다. | - |

