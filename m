From: Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Fix default behaviour for empty domains and add
 domainauto option
Date: Fri, 16 Dec 2016 15:06:20 +0000
Message-ID: <d7af3f88-6af4-e4a4-1b69-a6048a0e9b6f@citrix.com>
References: <1480022439-27875-2-git-send-email-germano.percossi@citrix.com>
 <CAKywueQ3UcOj3iFue4nh8EJTyeGc2-wHqr1_1qfU_T5rCkfSUg@mail.gmail.com>
 <CAH2r5ms2SUkzOda7xVXFStKBGMvt7J5V+P1vVQOzafbwfMAwQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5ms2SUkzOda7xVXFStKBGMvt7J5V+P1vVQOzafbwfMAwQQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Thank you guys.

It was a silly patch but most of the work was about understanding
what is the right default.

I was going to give more details on this because we had an internal
discussion about what is the expected behaviour for XenServer,
so I continued my comparisons with different servers, different
protocol versions, different authentication mechanism.

I'm glad you are OK with that so I don't have to bother you with
other details.

As promised, I will update the documentation for mount.cifs accordingly.

Let me know if you want the module documentation updated, too.

Regards,
Germano

On 12/15/2016 06:35 AM, Steve French wrote:
> merged into cifs-2.6.git
> 
> Germano,
> Thanks for the research into this
> 
> On Wed, Dec 14, 2016 at 2:10 PM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> 2016-11-24 13:20 GMT-08:00 Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>:
>>> With commit 2b149f119 many things have been fixed/introduced.
>>> However, the default behaviour for RawNTLMSSP authentication
>>> seems to be wrong in case the domain is not passed on the command line.
>>>
>>> The main points (see below) of the patch are:
>>>  - It alignes behaviour with Windows clients
>>>  - It fixes backward compatibility
>>>  - It fixes UPN
>>>
>>> I compared this behavour with the one from a Windows 10 command line
>>> client. When no domains are specified on the command line, I traced
>>> the packets and observed that the client does send an empty
>>> domain to the server.
>>> In the linux kernel case, the empty domain is replaced by the
>>> primary domain communicated by the SMB server.
>>> This means that, if the credentials are valid against the local server
>>> but that server is part of a domain, then the kernel module will
>>> ask to authenticate against that domain and we will get LOGON failure.
>>>
>>> I compared the packet trace from the smbclient when no domain is passed
>>> and, in that case, a default domain from the client smb.conf is taken.
>>> Apparently, connection succeeds anyway, because when the domain passed
>>> is not valid (in my case WORKGROUP), then the local one is tried and
>>> authentication succeeds. I tried with any kind of invalid domain and
>>> the result was always a connection.
>>>
>>> So, trying to interpret what to do and picking a valid domain if none
>>> is passed, seems the wrong thing to do.
>>> To this end, a new option "domainauto" has been added in case the
>>> user wants a mechanism for guessing.
>>>
>>> Without this patch, backward compatibility also is broken.
>>> With kernel 3.10, the default auth mechanism was NTLM.
>>> One of our testing servers accepted NTLM and, because no
>>> domains are passed, authentication was local.
>>>
>>> Moving to RawNTLMSSP forced us to change our command line
>>> to add a fake domain to pass to prevent this mechanism to kick in.
>>>
>>> For the same reasons, UPN is broken because the domain is specified
>>> in the username.
>>> The SMB server will work out the domain from the UPN and authenticate
>>> against the right server.
>>> Without the patch, though, given the domain is empty, it gets replaced
>>> with another domain that could be the wrong one for the authentication.
>>>
>>> Signed-off-by: Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
>>> ---
>>>  fs/cifs/cifsencrypt.c | 14 +++++++++-----
>>>  fs/cifs/cifsglob.h    |  2 ++
>>>  fs/cifs/connect.c     |  7 +++++++
>>>  3 files changed, 18 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
>>> index 5eb0412..66bd7fa 100644
>>> --- a/fs/cifs/cifsencrypt.c
>>> +++ b/fs/cifs/cifsencrypt.c
>>> @@ -699,11 +699,15 @@ static int crypto_hmacmd5_alloc(struct TCP_Server_Info *server)
>>>
>>>         if (ses->server->negflavor == CIFS_NEGFLAVOR_EXTENDED) {
>>>                 if (!ses->domainName) {
>>> -                       rc = find_domain_name(ses, nls_cp);
>>> -                       if (rc) {
>>> -                               cifs_dbg(VFS, "error %d finding domain name\n",
>>> -                                        rc);
>>> -                               goto setup_ntlmv2_rsp_ret;
>>> +                       if (ses->domainAuto) {
>>> +                               rc = find_domain_name(ses, nls_cp);
>>> +                               if (rc) {
>>> +                                       cifs_dbg(VFS, "error %d finding domain name\n",
>>> +                                                rc);
>>> +                                       goto setup_ntlmv2_rsp_ret;
>>> +                               }
>>> +                       } else {
>>> +                               ses->domainName = kstrdup("", GFP_KERNEL);
>>>                         }
>>>                 }
>>>         } else {
>>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>>> index 1f17f6b..4f0d5a1 100644
>>> --- a/fs/cifs/cifsglob.h
>>> +++ b/fs/cifs/cifsglob.h
>>> @@ -514,6 +514,7 @@ struct smb_vol {
>>>         bool persistent:1;
>>>         bool nopersistent:1;
>>>         bool resilient:1; /* noresilient not required since not fored for CA */
>>> +       bool domainauto:1;
>>>         unsigned int rsize;
>>>         unsigned int wsize;
>>>         bool sockopt_tcp_nodelay:1;
>>> @@ -827,6 +828,7 @@ struct cifs_ses {
>>>         enum securityEnum sectype; /* what security flavor was specified? */
>>>         bool sign;              /* is signing required? */
>>>         bool need_reconnect:1; /* connection reset, uid now invalid */
>>> +       bool domainAuto:1;
>>>  #ifdef CONFIG_CIFS_SMB2
>>>         __u16 session_flags;
>>>         __u8 smb3signingkey[SMB3_SIGN_KEY_SIZE];
>>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>>> index 4547aed..df7eed7 100644
>>> --- a/fs/cifs/connect.c
>>> +++ b/fs/cifs/connect.c
>>> @@ -88,6 +88,7 @@ enum {
>>>         Opt_multiuser, Opt_sloppy, Opt_nosharesock,
>>>         Opt_persistent, Opt_nopersistent,
>>>         Opt_resilient, Opt_noresilient,
>>> +       Opt_domainauto,
>>>
>>>         /* Mount options which take numeric value */
>>>         Opt_backupuid, Opt_backupgid, Opt_uid,
>>> @@ -176,6 +177,7 @@ enum {
>>>         { Opt_nopersistent, "nopersistenthandles"},
>>>         { Opt_resilient, "resilienthandles"},
>>>         { Opt_noresilient, "noresilienthandles"},
>>> +       { Opt_domainauto, "domainauto"},
>>>
>>>         { Opt_backupuid, "backupuid=%s" },
>>>         { Opt_backupgid, "backupgid=%s" },
>>> @@ -1499,6 +1501,9 @@ static int cifs_parse_security_flavors(char *value,
>>>                 case Opt_noresilient:
>>>                         vol->resilient = false; /* already the default */
>>>                         break;
>>> +               case Opt_domainauto:
>>> +                       vol->domainauto = true;
>>> +                       break;
>>>
>>>                 /* Numeric Values */
>>>                 case Opt_backupuid:
>>> @@ -2548,6 +2553,8 @@ static int match_session(struct cifs_ses *ses, struct smb_vol *vol)
>>>                 if (!ses->domainName)
>>>                         goto get_ses_fail;
>>>         }
>>> +       if (volume_info->domainauto)
>>> +               ses->domainAuto = volume_info->domainauto;
>>>         ses->cred_uid = volume_info->cred_uid;
>>>         ses->linux_uid = volume_info->linux_uid;
>>>
>>> --
>>> 1.9.1
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> Looks right to me.
>>
>> Acked-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
>>
>> --
>> Best regards,
>> Pavel Shilovsky
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
