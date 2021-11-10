#####################################################
#						 #
#	   Enterprise Architecture                 #
#		Walter Gonzalez			 #
#   Pasos para suscripciones nuevas Evertec LLC	 #
#						 #
#####################################################


1- Entrar a suscripcion en Partner Portal como usuario llc
1.1 - Crear suscripción bajo EvertecLLC
2- Desde Partner Portal entral a Azure Portal
3- Crear usuario (tu usuario como Owner) a nivel de la suscripcion nueva como Foreign Principal
4- Logout del portal y entrar con tu usuario, mover suscripcion bajo el Management Group llamado Evertec LLC
5- Crear el Management Group nuevo y usar nombre de la suscripcion para el Management Group nuevo donde ira la suscripcion que estamos trabajando
7- En el Azure Portal ir a la suscripcion y subir el Azure PowerShell crear primero el cloudshell RG y StorageAccount
8- Correr el script de registrar providers
9- Crear Automation Account aut-[account name]-runbook1 en un RG nuevo rg-[account name]-[env]-autoacc-[##]
10- Instalar los modulos de Azure en Automation Account (az.accounts, az.compute, az.automation, az.storage, az.resource, az.profile)
11- Crear los Runbooks(actualizar los parametros de los Tags y el Subscription ID de los PowerShells)
12- Publicar los runbooks llamados CreateTagsToAllResourceGroups y CreateBackupTagtoAllVm
13- Crearle un Schedule a los runbooks llamados CreateTagsToAllResourceGroups y CreateBackupTagtoAllVm, usar como nombre para el schedule: 
    sch-[account name]-prod-tag1, recurente, corre cada dia, de madrugada, horario de PR
14- Correr el runbook de CreateTagtoAllResources en cloudshell

Falta solo el crear la cuenta en Cloudcheckr una vez aparezca en el portal

------------------------------------------------------

15- Avisar a Seguridad de la suscripcion
16- Mover la suscripcion del Management Group Tenant Root al Management Group nuevo creado bajo el Evertec LLC Management Group(ver paso 5 y 6 (solo si es necesario))
16- Crear Management Group bajo EvertecLLC y mover la suscripcion al Management Group nuevo(ver paso 5 y 6 (solo si es necesario))
17- Eliminar tu usuario como Owner tanto de nuestro grupo de arquitectura como de usuarios de Seguridad, el permiso del grupo de Arquitectura es heredado desde el Management Group EvertecLLC
19- Correr los blueprints CommonPolicies, CommonResourceGroups, CreateEventHubName, CreateLogAnalyticsWorkspace, CreateStorageAccountforEventHub
20- Crear los Custom Roles ASG Team Monitoring [account name], ASGNetworkWatcher [account name], Network Watcher Managements [account name], Stop Restart Start VM [account name]
    Virtual Machine Update Manager [account name] (en plot crt se unificaron en un solo role Stop Restart Start VM+Virtual Machine Update Manager)
21- Asignar los permisos a los grupos de cada custom role

Rg-pvot-loganalytics-crt-01
Stop and Update Manager VM [subscription] crt





