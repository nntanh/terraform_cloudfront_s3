import boto3

# Thay đổi region thành region của bucket của bạn
region = 'ap-southeast-1'

# Danh sách các tên bucket cần xóa
bucket_names = ["aaa-nntanh76-s3bucket01", "aaa-nntanh76-s3bucket02", "aaa-nntanh76-s3bucket03"]

# Tạo một phiên làm việc với S3
s3 = boto3.client('s3', region_name=region)

# Lặp qua từng bucket và xóa các đối tượng trong đó
for bucket_name in bucket_names:
    # Lấy danh sách các đối tượng trong bucket
    objects = s3.list_objects_v2(Bucket=bucket_name)

    # Xóa từng đối tượng
    for obj in objects.get('Contents', []):
        object_key = obj['Key']
        s3.delete_object(Bucket=bucket_name, Key=object_key)

    print(f"Deleted {len(objects)} objects in {bucket_name}.")

    # Xóa bucket sau khi xóa hết đối tượng
    # s3.delete_bucket(Bucket=bucket_name)

print("All specified buckets and their contents have been deleted.")
