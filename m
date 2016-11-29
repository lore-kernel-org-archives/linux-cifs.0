From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] CIFS: iterate over posix acl xattr entry correctly in ACL_to_cifs_posix()
Date: Mon, 28 Nov 2016 23:16:48 -0600
Message-ID: <CAH2r5mtpPtnydUOsmBrx98mC9CXGhLLsxWf5dHmG8HLxZ9RBQA@mail.gmail.com>
References: <1477313200-26317-1-git-send-email-guaneryu@gmail.com> <20161121081658.GA1317@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Eryu Guan <guaneryu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161121081658.GA1317-+7p9VZFSOIEFmhoHi+V13ACJwEvxM/w9@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Yes - I will send a merge request tomorrow for this (if too late, then
we will add cc: stable and resend in a week or two)

On Mon, Nov 21, 2016 at 2:16 AM, Eryu Guan <guaneryu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Mon, Oct 24, 2016 at 08:46:40PM +0800, Eryu Guan wrote:
>> Commit 2211d5ba5c6c ("posix_acl: xattr representation cleanups")
>> removes the typedefs and the zero-length a_entries array in struct
>> posix_acl_xattr_header, and uses bare struct posix_acl_xattr_header
>> and struct posix_acl_xattr_entry directly.
>>
>> But it failed to iterate over posix acl slots when converting posix
>> acls to CIFS format, which results in several test failures in
>> xfstests (generic/053 generic/105) when testing against a samba v1
>> server, starting from v4.9-rc1 kernel. e.g.
>>
>>   [root@localhost xfstests]# diff -u tests/generic/105.out /root/xfstests/results//generic/105.out.bad
>>   --- tests/generic/105.out       2016-09-19 16:33:28.577962575 +0800
>>   +++ /root/xfstests/results//generic/105.out.bad 2016-10-22 15:41:15.201931110 +0800
>>   @@ -1,3 +1,4 @@
>>    QA output created by 105
>>    -rw-r--r-- root
>>   +setfacl: subdir: Invalid argument
>>    -rw-r--r-- root
>>
>> Fix it by introducing a new "ace" var, like what
>> cifs_copy_posix_acl() does, and iterating posix acl xattr entries
>> over it in the for loop.
>>
>> Signed-off-by: Eryu Guan <guaneryu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> Hi, any comments on this patch? I notice that it's not in 4.9-rc6,
> fstests generic/053 generic/105 generic/318 and generic/375 still fail
> when testing against samba 1.0 server. Will it be part of 4.9 kernel? It
> fixes a regression introduced in 4.9-rc1.
>
> Thanks,
> Eryu
>
>> ---
>> v2:
>> - move "ace" definition outside for loop
>>
>>  fs/cifs/cifssmb.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> index 3f3185f..e3fed92 100644
>> --- a/fs/cifs/cifssmb.c
>> +++ b/fs/cifs/cifssmb.c
>> @@ -3427,6 +3427,7 @@ static __u16 ACL_to_cifs_posix(char *parm_data, const char *pACL,
>>       __u16 rc = 0;
>>       struct cifs_posix_acl *cifs_acl = (struct cifs_posix_acl *)parm_data;
>>       struct posix_acl_xattr_header *local_acl = (void *)pACL;
>> +     struct posix_acl_xattr_entry *ace = (void *)(local_acl + 1);
>>       int count;
>>       int i;
>>
>> @@ -3453,8 +3454,7 @@ static __u16 ACL_to_cifs_posix(char *parm_data, const char *pACL,
>>               return 0;
>>       }
>>       for (i = 0; i < count; i++) {
>> -             rc = convert_ace_to_cifs_ace(&cifs_acl->ace_array[i],
>> -                     (struct posix_acl_xattr_entry *)(local_acl + 1));
>> +             rc = convert_ace_to_cifs_ace(&cifs_acl->ace_array[i], &ace[i]);
>>               if (rc != 0) {
>>                       /* ACE not converted */
>>                       break;
>> --
>> 2.7.4
>>



-- 
Thanks,

Steve
