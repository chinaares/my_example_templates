==============
my_example_templates
==============

## Confirming you can access a Heat endpoint
Before any Heat commands can be run, your cloud credentials need to be sourced:

```bash
$ source openrc
```
You can confirm that Heat is available with this command:
```bash
$ openstack stack list
```
This should return an empty line

## Preparing to create a stack
Your cloud will have different flavors and images available for launching instances, you can discover what is available by running:

```bash
$ openstack flavor list
```
```
+--------------------------------------+-----------+-------+------+-----------+-------+-----------+
| ID                                   | Name      |   RAM | Disk | Ephemeral | VCPUs | Is Public |
+--------------------------------------+-----------+-------+------+-----------+-------+-----------+
| 0c6507a5-1e8b-425b-af8e-c1d7a92abaad | m1.micro  |    64 |    0 |         0 |     1 | True      |
| 1                                    | m1.tiny   |   512 |    1 |         0 |     1 | True      |
| 2                                    | m1.small  |  2048 |   20 |         0 |     1 | True      |
| 3                                    | m1.medium |  4096 |   40 |         0 |     2 | True      |
| 4                                    | m1.large  |  8192 |   80 |         0 |     4 | True      |
| 5                                    | m1.xlarge | 16384 |  160 |         0 |     8 | True      |
+--------------------------------------+-----------+-------+------+-----------+-------+-----------+
```
```bash
$ openstack image list
```
```
+--------------------------------------+--------+--------+
| ID                                   | Name   | Status |
+--------------------------------------+--------+--------+
| dd19e087-5cc4-4dac-8d36-0916dd2f3c29 | TestVM | active |
+--------------------------------------+--------+--------+
```

To allow you to SSH into instances launched by Heat, a keypair will be generated:
```bash
$ openstack keypair create heat_key > heat_key.priv
$ chmod 600 heat_key.priv
```

## Launching a stack
Now lets launch a stack, using an example template from the heat-templates repository:
```bash
$ heat stack-create -u http://git.openstack.org/cgit/openstack/heat-templates/plain/hot/F20/WordPress_Native.yaml -P key_name=heat_key -P image_id=my-fedora-image -P instance_type=m1.small teststack
```

Which will respond:
```
+--------------------------------------+-----------+--------------------+----------------------+
| ID                                   | Name      | Status             | Created              |
+--------------------------------------+-----------+--------------------+----------------------+
| (uuid)                               | teststack | CREATE_IN_PROGRESS | (timestamp)          |
+--------------------------------------+-----------+--------------------+----------------------+
```
Note Link on Heat template presented in command above should reference on RAW template. In case if it be a “html” page with template, Heat will return an error.

## List stacks

*  List the stacks in your tenant:
```bash
$ openstack stack list
```

## List stack events

*  List the events related to a particular stack:
```bash
$ openstack stack event list teststack
```
Describe the wordpress stack

*  Show detailed state of a stack:
```bash
$ openstack stack show teststack
```
Note: After a few seconds, the stack_status should change from IN_PROGRESS to CREATE_COMPLETE.

## Verify instance creation

Because the software takes some time to install from the repository, it may be a few minutes before the Wordpress instance is in a running state.

Point a web browser at the location given by the WebsiteURL output as shown by heat output-show:
```bash
$ WebsiteURL=$(heat output-show --format raw teststack WebsiteURL)
$ curl $WebsiteURL
```

## Delete the instance when done

Note: The list operation will show no running stack.:
```bash
$ openstack stack delete teststack
$ openstack stack list
```
