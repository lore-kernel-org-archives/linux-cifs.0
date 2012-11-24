From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Upgrading security default
Date: Fri, 23 Nov 2012 22:09:56 -0600
Message-ID: <CAH2r5mtrTcgEbPEtEuu=FnXq8yOJhvc94LRNVPqDBfR+T83xJQ@mail.gmail.com>
References: <CAH2r5mtPAwURZxTeRBfn+c=hNyeaDbmKbYXt=w3VkUu5i1cxNQ@mail.gmail.com>
	<20121123204136.5466f0e9@corrin.poochiereds.net>
	<CAH2r5msv_gp8Vpx82zA084awe++kFd5S3X7==6K2g6c7jBhCOg@mail.gmail.com>
	<CAH2r5mtqyBgKx2_FyAOVpML+g-uOb1ZcocXUG2Q-4EnvHtr_Ew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtqyBgKx2_FyAOVpML+g-uOb1ZcocXUG2Q-4EnvHtr_Ew-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Nov 23, 2012 at 8:52 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> changing
> #define   CIFSSEC_DEF (CIFSSEC_MAY_SIGN | CIFSSEC_MAY_NTLM |
> CIFSSEC_MAY_NTLMV2 | CIFSSEC_MAY_NTLMSSP)
>
> to
>
> #define   CIFSSEC_DEF (CIFSSEC_MAY_SIGN | CIFSSEC_MAY_NTLMSSP)
>
> affects more code

It does seem to work - global_secflag is touched in more places, but
looks safe enough as an alternative.  Do you prefer the other change?

> On Fri, Nov 23, 2012 at 8:48 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> it doesn't change security flags - but it seemed the smallest and
>> safest since it basically says:
>> 1) if you pass in "sec=" then use that
>> 2) otherwise use ntlmssp (with ntlmv2)
>>
>> so shouldn't have any unintended consequences (and the sign mount
>> option should work as expected as well)
>>
>> On Fri, Nov 23, 2012 at 7:41 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>> On Fri, 23 Nov 2012 17:36:45 -0600
>>> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>
>>>> This patch to upgrade the default security mechanism to ntlmv2/ntlmssp
>>>> (which is broadly supported for years now, and a reasonable minimum,
>>>> far better than ntlm) is overdue, but I had to rework it to simplify
>>>> it.
>>>>
>>>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>>>> index 5c670b9..3bca289 100644
>>>> --- a/fs/cifs/connect.c
>>>> +++ b/fs/cifs/connect.c
>>>> @@ -1103,6 +1103,7 @@ cifs_parse_mount_options(const char *mountdata,
>>>> const char *devname,
>>>>       bool uid_specified = false;
>>>>       bool gid_specified = false;
>>>>       bool sloppy = false;
>>>> +     bool sec_explicitly_set = false;
>>>>       char *invalid = NULL;
>>>>       char *nodename = utsname()->nodename;
>>>>       char *string = NULL;
>>>> @@ -1763,6 +1764,7 @@ cifs_parse_mount_options(const char *mountdata,
>>>> const char *devname,
>>>>
>>>>                       if (cifs_parse_security_flavors(string, vol) != 0)
>>>>                               goto cifs_parse_mount_err;
>>>> +                     sec_explicitly_set = true;
>>>>                       break;
>>>>               case Opt_cache:
>>>>                       string = match_strdup(args);
>>>> @@ -1799,6 +1801,8 @@ cifs_parse_mount_options(const char *mountdata,
>>>> const char *devname,
>>>>               goto cifs_parse_mount_err;
>>>>       }
>>>>  #endif
>>>> +     if (sec_explicitly_set == false)
>>>> +             vol->secFlg |= CIFSSEC_MAY_NTLMSSP;
>>>>
>>>>       if (vol->UNCip == NULL)
>>>>               vol->UNCip = &vol->UNC[2];
>>>> @@ -2397,8 +2401,6 @@ cifs_set_cifscreds(struct smb_vol *vol
>>>> __attribute__((unused)),
>>>>  }
>>>>  #endif /* CONFIG_KEYS */
>>>>
>>>> -static bool warned_on_ntlm;  /* globals init to false automatically */
>>>> -
>>>>  static struct cifs_ses *
>>>>  cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
>>>>  {
>>>> @@ -2475,14 +2477,6 @@ cifs_get_smb_ses(struct TCP_Server_Info
>>>> *server, struct smb_vol *volume_info)
>>>>       ses->cred_uid = volume_info->cred_uid;
>>>>       ses->linux_uid = volume_info->linux_uid;
>>>>
>>>> -     /* ntlmv2 is much stronger than ntlm security, and has been broadly
>>>> -     supported for many years, time to update default security mechanism */
>>>> -     if ((volume_info->secFlg == 0) && warned_on_ntlm == false) {
>>>> -             warned_on_ntlm = true;
>>>> -             cERROR(1, "default security mechanism requested.  The default "
>>>> -                     "security mechanism will be upgraded from ntlm to "
>>>> -                     "ntlmv2 in kernel release 3.3");
>>>> -     }
>>>>       ses->overrideSecFlg = volume_info->secFlg;
>>>>
>>>>       mutex_lock(&ses->session_mutex);
>>>>
>>>
>>> How does this change the SecurityFlags interface?
>>>
>>> --
>>> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>
>>
>>
>> --
>> Thanks,
>>
>> Steve
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
