import subprocess
import time
import datetime

def get_gpu_memory_usage():
    try:
        output = subprocess.check_output(['nvidia-smi', '--query-gpu=memory.used,memory.total', '--format=csv,nounits,noheader'])
        used, total = map(int, output.decode('utf-8').strip().split(','))
        return used, total
    except subprocess.CalledProcessError:
        return None, None

def check_gpu_memory_usage(threshold, max_attempts, retry_interval):
    for _ in range(max_attempts):
        used, total = get_gpu_memory_usage()
        if used is not None and total is not None:
            gpu_usage_percentage = used / total
            if gpu_usage_percentage > threshold:
                print(f"GPU memory usage is above {threshold*100}%: {gpu_usage_percentage*100}%")
                time.sleep(retry_interval)
            else:
                print(f"GPU memory usage is below {threshold*100}%: {gpu_usage_percentage*100}%")
                return
        else:
            print("Failed to retrieve GPU memory information. Retrying...")
            time.sleep(retry_interval)

    print(f"GPU memory usage is consistently above {threshold*100}% after {max_attempts} attempts. Restarting sd-service...")
    # Add your code to restart the sd-service here
    cmd = "sudo service sd-service restart"
    subprocess.call(cmd, shell=True)
    cmd = "sudo service sd-service status"
    try:
        status_output = subprocess.check_output(cmd, shell=True, stderr=subprocess.STDOUT)
        print(status_output.decode("utf-8"))
    except subprocess.CalledProcessError as e:
        # If there's an error (e.g., the service doesn't exist), print the error message
        print(f"Error running status command: {e.output.decode('utf-8')}")

if __name__ == '__main__':
    threshold = 0.85    # 
    max_attempts = 10   # times
    retry_interval = 10  # seconds

    print(f"====== Script started at: {datetime.datetime.now()} ======")
    check_gpu_memory_usage(threshold, max_attempts, retry_interval)
    print(f"====== Script ended at: {datetime.datetime.now()} ======")
