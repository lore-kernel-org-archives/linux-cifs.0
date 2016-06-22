From: Bastian Arjun Shajit <bastian-yrGDUoBaLx3QT0dZR+AlfA@public.gmane.org>
Subject: Re: PROBLEM: Attempting to create subdirectory returns error after
 removing parent directory with child entries using rmdir()
Date: Wed, 22 Jun 2016 23:23:18 +0300
Message-ID: <576AF3B6.7070909@tuxera.com>
References: <576A9356.2010701@tuxera.com> <576A9423.6090505@tuxera.com>
 <6d5f3758e7b946a9a6d9e629cac722a5@nebula-exfe-02.nebula.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6d5f3758e7b946a9a6d9e629cac722a5-SUpINa3nmyRMOBdrsOXnL7H8+uLQl0YSwzqs5ZKRSiY@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Steve,

On 22.06.2016 18:48, Steve French wrote:
> Does this patch which is in recent kernels change the behavior:
>
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/fs/cifs?id=897fba1172d637d344f009d700f7eb8a1fa262f1
I think this patch might solve the problem. I will test and update asap.

Br,
Bastian
>
> On Wed, Jun 22, 2016 at 8:35 AM, Bastian Arjun Shajit
> <bastian-yrGDUoBaLx3QT0dZR+AlfA@public.gmane.org> wrote:
>> Hi,
>>
>> We encountered the following error or unexpected behaviour when
>> following the steps given below:
>>
>> 1. Mount the remote share exported by either windows or samba using the
>> following command:
>> sudo mount -t cifs -o
>> port=445,vers=2.1,username=<username>,password=password,noperm,actimeo=0
>> //<IP>/SH1 /mnt/test && cd /mnt/test
>>
>> 2. Run the attached program on the mounted share. You should see the
>> following output:
>>
>> **bastian@gutbark-UX32VD:/mnt/test$ /KVMstorage/cifs_dir_bug
>> ** [4428] mkdir ./parentdir 0777
>> ** [4428] mkdir ./parentdir/sub.0 0777
>> ** [4428] chdir ./parentdir/sub.0
>> ** [4428] rmdir /mnt/test/parentdir
>> !! [4428] stat() /mnt/test/parentdir Success
>> ** [4428] mkdir /mnt/test/parentdir/sub.1
>> !! [4428] mkdir /mnt/test/parentdir/sub.1 failed(No such file or directory)
>>
>> You can see from the above logs, stat of parentdir is successful but
>> creating a new child directory under the parent fails.
>>
>> The attached program does the following:
>> a. Create a parent directory
>> b. Create a sub-directory under the parent.
>> c. Change dir to sub-directory
>> d. Now delete the parent directory using absolute path from the cifs
>> client using "rmdir".
>>
>> The POSIX behaviour for rmdir() is that if there are entries other than
>> "." and ".." it must return ENOTEMPTY error. But as per SMB2 protocol
>> specification, we delete a directory by:
>> a. Open directory with "Delete on Close" Flag set in the "CreateOptions"
>> field of the SMB2 CREATE request.
>> b. Close the open handle returned in the response for the previous request.
>>
>> As per SMB2 specification, the SMB2 close will always return NT status
>> STATUS_SUCCESS for removing the directory even if the directory has
>> child entries, but the server does not delete the directory itself.
>>
>> 4. Manually running "tree" on the mounted share shows the following:
>> bastian@gutbark-UX32VD:/mnt/test$ tree
>> .
>> |__parentdir
>> 1 directory, 0 files
>>
>> We clearly see above that the parent directory does not show any child
>> directories.
>>
>> 5.Now we unmount and mount the remote share again
>> bastian@gutbark-UX32VD:/mnt/test$ cd / && sudo umount /mnt/test
>> bastian@gutbark-UX32VD:/KVMstorage/$ sudo mount -t cifs -o
>> port=445,vers=2.1,username=<Username>,password=password,noperm,actimeo=0
>> //<IP>/SH1 /mnt/test && cd /mnt/test
>> bastian@gutbark-UX32VD:/mnt/test$ tree
>> .
>> |__parentdir
>>             |__ sub.0
>> 2 directories, 0 files//
>>
>> As you can see, remounting the remote share now displays a subdirectory
>> which was not displayed in the earlier mount cycle.
>>
>> We used the following test setup for reproducing the above said issue:
>> 1. Cifs client: Version = 2.06, Linux versions: Ubuntu, 3.19.8-ckt5 &
>> 3.16.0-49-generic
>> 2. Server: Windows 8.1 pro, Windows 7, Samba 4.1.6-Ubuntu.
>> 3. Reproducible only on SMB2 protocol version.
>>
>> The issue was reproducible always on WIndows SMB server whereas on Samba
>> server we were able to reproduce 1/2 times.
>>
>> We ran the same tests on CIFS client version: 2.08, Linux versions 4.4
>> and 4.5 and we were unable to reproduce the issue.
>>
>> Br,
>> Bastian
>>
>
>
