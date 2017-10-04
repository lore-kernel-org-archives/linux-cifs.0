From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Fake rwx permissions if we can not read the CIFS ACL
Date: Wed, 4 Oct 2017 17:07:02 -0500
Message-ID: <CAH2r5msFuxZnYhyrgEExChLNb5_nM-8mn7ndq2=c2HAPW-uiDA@mail.gmail.com>
References: <20171004045953.28134-1-lsahlber@redhat.com> <CAH2r5muHtkLFHkrKdmto04E=LSLn3BXJ54h4uGnhip7E0Z-hzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muHtkLFHkrKdmto04E=LSLn3BXJ54h4uGnhip7E0Z-hzQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

and added cc:stable

On Wed, Oct 4, 2017 at 5:06 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> merged into cifs-2.6.git for-next but notice minor nit about comments
> (always run checpatch before submitting)
>
> WARNING: Block comments use * on subsequent lines
> #85: FILE: fs/cifs/cifsacl.c:1160:
> +            /* If we do not have permission to read the ACL
> +               just clear all rwx permissions */
>
> On Tue, Oct 3, 2017 at 11:59 PM, Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> If the cifsacl mount option is used and we try to list a directory that
>> contains entries where we do not have READ_CONTROL access we will see errors
>> such as "ls: cannot access '...': Permission denied"
>> and the directory listing will show files with funny attributes like
>> "-?????????? ? ?    ?    ?            ? foo002.txt"
>>
>> This patch fixes this by checking the error from reading the security
>> descriptor and if it failed with EACCES we fake the attributes as
>> all 0.
>>
>> Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  fs/cifs/cifsacl.c | 10 +++++++++-
>>  1 file changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
>> index b98436f5c7c7..11d0d135a9b7 100644
>> --- a/fs/cifs/cifsacl.c
>> +++ b/fs/cifs/cifsacl.c
>> @@ -1155,7 +1155,15 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
>>         /* if we can retrieve the ACL, now parse Access Control Entries, ACEs */
>>         if (IS_ERR(pntsd)) {
>>                 rc = PTR_ERR(pntsd);
>> -               cifs_dbg(VFS, "%s: error %d getting sec desc\n", __func__, rc);
>> +               if (rc == -EACCES) {
>> +                       /* If we do not have permission to read the ACL
>> +                          just clear all rwx permissions */
>> +                       cifs_dbg(NOISY, "%s: EACCES reading ACL\n", __func__);
>> +                       fattr->cf_mode &= ~(S_IRWXUGO);
>> +                       rc = 0;
>> +               } else
>> +                       cifs_dbg(VFS, "%s: error %d getting sec desc\n",
>> +                                __func__, rc);
>>         } else {
>>                 rc = parse_sec_desc(cifs_sb, pntsd, acllen, fattr);
>>                 kfree(pntsd);
>> --
>> 2.13.3
>>
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
