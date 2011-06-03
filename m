From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix the kernel release version in the default
 security warning message
Date: Fri, 3 Jun 2011 11:26:00 -0500
Message-ID: <BANLkTik3B5rZbOy6aPCN09dwWhtRDExhjw@mail.gmail.com>
References: <4DE880E3.8020502@suse.de>
	<20110603091119.7596fade@corrin.poochiereds.net>
	<4DE90669.5020108@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DE90669.5020108-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Jun 3, 2011 at 11:06 AM, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> =
wrote:
> On 06/03/2011 06:41 PM, Jeff Layton wrote:
>> On Fri, 03 Jun 2011 12:06:19 +0530
>> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
>>
>>>
>>> When ntlm security mechanim is used, the message that warns about t=
he upgrade
>>> to ntlmv2 got the kernel release version wrong (Blame it on Linus :=
). Fix it.
>>>
>>> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
>>> ---
>>> =A0fs/cifs/connect.c | =A0 =A02 +-
>>> =A01 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>>> index 6d88b82..84c7307 100644
>>> --- a/fs/cifs/connect.c
>>> +++ b/fs/cifs/connect.c
>>> @@ -1976,7 +1976,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *serv=
er, struct smb_vol *volume_info)
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0warned_on_ntlm =3D true;
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "default security mechanism re=
quested. =A0The default "
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"security mechanism will=
 be upgraded from ntlm to "
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"ntlmv2 in kernel release =
2.6.41");
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"ntlmv2 in kernel release =
3.1");
>>> =A0 =A0 =A0}
>>> =A0 =A0 =A0ses->overrideSecFlg =3D volume_info->secFlg;
>>>
>>
>> Looks good. Though I'm not sure whether we should call it 3.1.0?
>> Regardless...
>
> I thought about this. But, as Linus has already said:
>
> "Now, my alpha-maleness sadly does not actually extend to all the
> scripts and Makefile rules, so the kernel is fighting back, and is
> calling itself 3.0.0-rc1. We'll have the usual 6-7 weeks to wrestle i=
t
> into submission, and get scripts etc cleaned up, and the final releas=
e
> should be just "3.0". The -stable team can use the third number for
> their versioning."
>
> I think 3.1 should be ok?

Yes.



--=20
Thanks,

Steve
