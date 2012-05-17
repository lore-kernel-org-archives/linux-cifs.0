From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: don't send a mandatory ver= option to the kernel
Date: Thu, 17 May 2012 12:03:26 -0500
Message-ID: <CAH2r5muvJ=QUt6MsYQiZpZDWp+GRzviJRnJ6Q7O5eE1zYNOnJg@mail.gmail.com>
References: <1336763001-7315-1-git-send-email-jlayton@samba.org>
	<1337273046.2275.1.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337273046.2275.1.camel@localhost>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, May 17, 2012 at 11:44 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
> On Fri, 2012-05-11 at 15:03 -0400, Jeff Layton wrote:
>> Traditionally, this ver=3D option was used to specify the "options
>> version" that we're passing in. It has always been set to '1' though
>> and we have never changed that.
>>
>> Eventually we want to have a ver=3D (or vers=3D) option that allows =
users
>> to specify the SMB version that they want to use to talk to the serv=
er.
>>
>> At that point, this option will just get in the way. Let's go ahead
>> and remove it now in preparation for that day.
>>
>
> Do we need 'ver=3D' mount option to specify the SMB version number? I=
sn't
> 'vers=3D' sufficient for this?

Yes - "vers" is sufficient (although I am fine with adding synonyms to
make it easier for nfs users - e.g. "smbvers=3D" or if we want to have
smb2 specific utility programs (e.g. for a phone or tablet) that call
do_mount automatically set vers=3D2.1.

I think that there will be times when we want (the kernel cifs.ko) to
know the version number of the user space utility (bugs? security
problems? debugging mount errors, at least when debugging set to
maximum level to log to dmesg?) so I think we should pass the real
mount.cifs version number in "ver=3D" as was the original intent (if fo=
r
nothing else it would help debugging mount bugs so we could log it to
dmesg in a few cases) - but since we have been sending "1" instead of
the mount.cifs version (and it is not currently used by the kernel
code) I can understand Jeff's point.  In any case, we can't use "ver=3D=
"
to mean "vers=3D" (ie the requested dialect the user wants to use) as i=
f
so current mount.cifs will force cifs by sending "ver=3D1" and when we
want to move the default in the future it would get in the way
(cifs.ko would require an update of mount.cifs but we would have no
way of telling in kernel whether it was the old mount.cifs - kind of a
catch-22 due to the lack of version number)


>> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>> ---
>> =A0mount.cifs.c | =A0 20 +++++++-------------
>> =A01 files changed, 7 insertions(+), 13 deletions(-)
>>
>> diff --git a/mount.cifs.c b/mount.cifs.c
>> index 0408158..3041987 100644
>> --- a/mount.cifs.c
>> +++ b/mount.cifs.c
>> @@ -100,12 +100,6 @@
>> =A0#define MAX_DOMAIN_SIZE 64
>>
>> =A0/*
>> - * value of the ver=3D option that gets passed to the kernel. Used =
to indicate
>> - * behavioral changes introduced in the mount helper.
>> - */
>> -#define OPTIONS_VERSION "1"
>> -
>> -/*
>> =A0 * mount.cifs has been the subject of many "security" bugs that h=
ave arisen
>> =A0 * because of users and distributions installing it as a setuid r=
oot program
>> =A0 * before it had been audited for security holes. The default beh=
avior is
>> @@ -1833,21 +1827,21 @@ assemble_mountinfo(struct parsed_mount_info =
*parsed_info,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto assemble_exit;
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 /* copy in ver=3D string. It's not really needed, but what=
 the hell */
>> - =A0 =A0 if (*parsed_info->options)
>> - =A0 =A0 =A0 =A0 =A0 =A0 strlcat(parsed_info->options, ",", sizeof(=
parsed_info->options));
>> - =A0 =A0 strlcat(parsed_info->options, "ver=3D", sizeof(parsed_info=
->options));
>> - =A0 =A0 strlcat(parsed_info->options, OPTIONS_VERSION, sizeof(pars=
ed_info->options));
>> -
>> =A0 =A0 =A0 /* copy in user=3D string */
>> =A0 =A0 =A0 if (parsed_info->got_user) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 strlcat(parsed_info->options, ",user=3D",
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (*parsed_info->options)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 strlcat(parsed_info->optio=
ns, ",",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(par=
sed_info->options));
>> + =A0 =A0 =A0 =A0 =A0 =A0 strlcat(parsed_info->options, "user=3D",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(parsed_info->opti=
ons));
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 strlcat(parsed_info->options, parsed_inf=
o->username,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(parsed_info->opti=
ons));
>> =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 if (*parsed_info->domain) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (*parsed_info->options)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 strlcat(parsed_info->optio=
ns, ",",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(par=
sed_info->options));
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 strlcat(parsed_info->options, ",domain=3D=
",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(parsed_info->opti=
ons));
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 strlcat(parsed_info->options, parsed_inf=
o->domain,



--=20
Thanks,

Steve
