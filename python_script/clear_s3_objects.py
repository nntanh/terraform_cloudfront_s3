import boto3

region = 'ap-southeast-1'
bucket_names = ["aaa-nntanh76-s3bucket01", "aaa-nntanh76-s3bucket02", "aaa-nntanh76-s3bucket03"]

# choose s3 resouce to work
s3 = boto3.client('s3', region_name=region)

for bucket_name in bucket_names:
    # List all versions of objects in the bucket
    object_versions = s3.list_object_versions(Bucket=bucket_name)

    # Delete all versions of objects in the bucket
    for version in object_versions.get('Versions', []):
        object_key = version['Key']
        version_id = version['VersionId']

        # Delete each version of the object
        s3.delete_object(Bucket=bucket_name, Key=object_key, VersionId=version_id)

    print(f"Deleted all versions in {bucket_name}.")

    # get objects list
    objects = s3.list_objects_v2(Bucket=bucket_name)

    # remove each object
    for obj in objects.get('Contents', []):
        object_key = obj['Key']
        s3.delete_object(Bucket=bucket_name, Key=object_key)

    print(f"Deleted all versions in {bucket_name}.")
    # print(f"Deleted {len(objects)} objects in {bucket_name}.")

    # remove all s3 buckets
    # s3.delete_bucket(Bucket=bucket_name)

print("All specified buckets and their contents have been deleted.")
