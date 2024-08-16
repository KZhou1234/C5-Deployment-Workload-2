# Kura Labs Cohort 5- Deployment Workload 2
## CICD with AWS CLI:  

Previously, we built and tested the application successfully in Jenkins, but we needed to manually upload the code for deployment and configure Elastic Beanstalk in the AWS console. It was very easy to make mistakes when manually releasing the code to production, and it actually happened to me. In this exercise, the goal is to automate the deployment process in Jenkins.
## SYSTEM DESIGN DIAGRAM
<div align="center">
	<img width="1471" alt="image" src="https://github.com/user-attachments/assets/2ccb9144-8a0b-4095-8cc7-cea682305023">

  </div> 

## STEPS

1. Prepare the remote repository on GitHub, which is a version control system. Jenkins will then automatically take the latest version. This setup also allows team members to work on the same project simultaneously. 
	

2. Create my Access Key for the Command Line Interface (CLI). An AWS access key is required when programmatically interacting with AWS services. In this workload, I would manage AWS resources through the CLI, so I'll need the access key later to authenticate my commands. Since this access key can only be viewed once, it is important to store it securely. Additionally, the exposure of the access key can lead to data breaches and unauthorized access to AWS resources. Therefore, it is crucial to keep it safe.

3. Create a t2.micro EC2 instance for the Jenkins server. This instance will provide system resources for Jenkins to build, test, and deploy the application.
	<div align="center">
	<img width="1406" alt="Jnkins run" src="https://github.com/user-attachments/assets/ac3ff40d-25d4-4922-8fd5-e31e470fd5c2">
	
	</div> 
4. Create a BASH script called "system_resources_test.sh" that checks for system resources (can be memory, cpu, disk, all of the above and/or more).  and push it to the GH repo. IMPORTANT: make sure you use conditional statements and exit codes (0 or 1) if any resource exceeds a certain threshold.  
    <div align="center">
	  <img width="580" alt="exit 1 should be memoery exceed the thd" src="https://github.com/user-attachments/assets/e183c9a2-86b8-4b4d-b2ec-2eaf4c92255e">

	</div>  
 	CPU load is defined as the number of processes using or waiting to use one core at a single point in time.  
    System resources can greatly affect application performance. It is crucial to monitor storage, memory and CPU.  
    The resource utilization need some command to check and a liitle calculation.    
    	 
 
    a. We can use the `top` command to display real-time information about system processes. Using the -b option indicates that we can process data in batch mode instead of continuously displaying it.

    <div align="center">
	    <img width="948" alt="run top to monitor where to find cpu usage" src="https://github.com/user-attachments/assets/01410ced-3733-4bdf-b9a2-39a23205f624">
	</div>  
    b. As seen in the screenshot, we can then use `grep %CPU` to filter the rows for CPU monitoring. Identify the number before `id`, which represents the idle CPU percentage. Subtract this number from 100 to calculate the CPU utilization.
	<div align="center">
	    <img width="853" alt="cpu usage and idle" src="https://github.com/user-attachments/assets/5e3e6c4b-47d8-4d67-9ece-8caf2d8d4990">

	</div> 
   
    c. To get memory usage, we can use the `free` command. The free command provides multiple metrics for memory. In this case, I’ve selected total memory and used memory; the quotient represents the percentage of memory usage.
	<div align="center">
	  <img width="845" alt="mem chck with grep" src="https://github.com/user-attachments/assets/fdea9da9-d37a-4e06-9c6e-f5999684fc8c">



	</div>
   
    d. To get disk usage, we can use the `df` command, with `df /` providing the disk usage of the root directory.
	<div align="center">
	  <img width="698" alt="disk check" src="https://github.com/user-attachments/assets/e3ad900d-767a-487b-bd74-f078cfc5d7d5">




	</div>
   
    e. I initially set the threshold for each usage to 65 percent, which is a normal threshold for monitoring the system. If any of these exceed the threshold, the process will exit with code 1 and display an error message to handle errors. In this CI/CD pipeline, the exit code is used for error detection, if certain failure conditions are met, the build can be stopped, allowing developers to debug or take other actions depending on the exit code before releasing the product.
	<div align="center">
	   <img width="626" alt="cpu usage above threshold" src="https://github.com/user-attachments/assets/b976a76f-4032-4155-b6b8-bf43dce30c6c">
	</div>



6. Create a MultiBranch Pipeline and connect the GH repo to it   <div align="center">
	<img width="1232" alt="github conncted to Jenkins" src="https://github.com/user-attachments/assets/a53648a7-d91b-4c5d-9d9a-53737fd3c5c6">

	
	</div> 

7. Back in the Jenkins Server Terminal- Install AWS CLI on the Jenkins Server
	<div align="center">
		<img width="794" alt="aws version" src="https://github.com/user-attachments/assets/17334be5-0bf9-4a76-8169-5461500dfb6a">
	
	</div> 


7. Prepare the environment for deployment as a Jenkins user. 


8. Activate the Python Virtual Environment

```
source venv/bin/activate
```  

To run the application, we can create a virtual environment to isolate dependencies and avoid conflicts. By looking at the Jenkinsfile, we can see that the virtual environment was created by `python3.7 -m venv venv`, we can activate it directly and then configure in the virtual environment.  

9. Install AWS EB CLI on the Jenkins Server   
	<div align="center">
		<img width="732" alt="eb installed" src="https://github.com/user-attachments/assets/eb64ce43-84ce-40c3-aba5-cc10d12cdd00">

	
	</div> 
10. Configure AWS CLI


In previous experiences, I configured the deployment environment through the Elastic Beanstalk console, selecting the region, role, and platform. In this exercise, I accomplished these tasks using the CLI by selecting different options.

11. Add a "deploy" stage to the Jenkinsfile. Now `eb create [enter-name-of-environment-here] --single` did the same thing as create a deplomyment environment in EB console. By following this file, Jenkins now can automatically deploy the latest version of code. We can free from uploading the right version manually.



12. Navigate back to the Jenkins Console and build the pipeline again.

	<div align="center">
		<img width="1482" alt="venv running" src="https://github.com/user-attachments/assets/0bb87612-bca2-455c-a786-77bf35185918">
	<img width="1137" alt="environment run" src="https://github.com/user-attachments/assets/43d40ef2-6706-40c8-91bf-d05a1bf6e636">
	</div> 

13. Done
	<div align="center">
		<img width="1920" alt="done" src="https://github.com/user-attachments/assets/a491f353-fd15-4776-83c8-b169b21a906d">
	</div>

## TROUBLESHOOTING
1. I am experiencing high memory utilization during the build process in Jenkins. While building the application, I encountered multiple failures due to this high memory usage. I initially set the memory usage threshold to 65%, but I continued to face failures, which prompted me to increase the threshold incrementally. Eventually, I reached 95%, which I think is a bad signal.
 	<div align="center">
		<img width="516" alt="image" src="https://github.com/user-attachments/assets/5a17b0a3-7d88-4728-8d98-848f36f46514">

	</div>


Several factors could cause this problem:

* The server I’m using is a t2.micro, which has limited CPU and memory resources. It may perform better for smallar applications.
* Jenkins is running on this server and needs to clone or pull from GitHub, which consumes memory.
* I am also using this server as a local storage solution to store and process files, which further consumes memory and disk space.
* This being solved by increasing the threshold for memory usage. 
2. I've also have servral tries for calculation the cpu usage, at the first time I tried to split the line using cammand `grep -P '(....|...) id,'`; when the idle cpu is 100%, it cannot match this pattern. Then I tried the current way to get the cpu utilization.
	<div align="center">
		<img width="1030" alt="troubleshooting cpu calculating" src="https://github.com/user-attachments/assets/fa5c3073-bf26-4034-97f9-4ff89d02dffc">
	
	</div>

## OPTIMIZATION
  ### How is using a deploy stage in the CICD pipeline able to increase efficiency of the business?   
  * By using the deploy stage, we can now configure the pipeline satges by telling the Jenkins to create a Elastic Beanstalk environment and it can deploy automatically. Reduced the marketing time for production.
  * Continuous delivery also improves the user experience by reducing maintenance time.

    
### What issues, if any, can you think of that might come with automating source code to a production environment? How would you address/resolve this?  
  * It is possible to have deployment failures even through automating the source code. As in my working, if the Jenkinsfile has some issues with the configuration, such as using the duplicate environment name, will cause deployment failure. The solution would be using proper error handling.


## CONCLUSION
Prior to step 5, we primarily repeated the steps from workload 1 to configure Jenkins for automatic building and testing. Plus I practiced using scripts to monitor system resources and set proper thresholds to ensure application performance. Starting from step 6, I've configured the Jenkinsfile by adding the deploy stage to the pipeline and set up the virtual environment through the CLI instead of the EC2 console. All settings remained the same; we just added one more step to use the access key in the CLI for authentication to access the resources. As a result, we successfully implemented a CI/CD pipeline that enables automatic and continuous integration and delivery. Through the diagram process also investigated more about the VPC, IAM and Elastic Beanstalk in AWS, as well as the Nginx and Gunicorn.
    
