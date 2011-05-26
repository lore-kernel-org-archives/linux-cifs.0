From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [v4 PATCH 4/4] CIFS: Migrate to shared superblock model
Date: Thu, 26 May 2011 20:17:37 +0400
Message-ID: <BANLkTikkbBO6iZsf7ckUFFiMdUbuLi7HNA@mail.gmail.com>
References: <1306389721-28550-1-git-send-email-piastry@etersoft.ru>
	<1306389721-28550-4-git-send-email-piastry@etersoft.ru>
	<20110526112001.6602ce52@corrin.poochiereds.net>
	<BANLkTim+a8swvWytQwUQqE+1s+wVnX3gRg@mail.gmail.com>
	<BANLkTi==YrNa1quPtEFW0T3_yxCrCq_+sA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTi==YrNa1quPtEFW0T3_yxCrCq_+sA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/5/26 Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>:
> 2011/5/26 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> On Thu, May 26, 2011 at 10:20 AM, Jeff Layton <jlayton@poochiereds.n=
et> wrote:
>>> On Thu, 26 May 2011 10:02:01 +0400
>>> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>>>
>>>> Add cifs_match_super to use in sget to share superblock between mo=
unts
>>>> that have the same //server/sharename, credentials and mount optio=
ns.
>>>> It helps us to improve performance on work with future SMB2.1 leas=
es.
>> <snip>
>>>> +static int
>>>> +compare_mount_options(struct super_block *sb, struct cifs_mnt_dat=
a *mnt_data)
>>>> +{
>>>> + =A0 =A0 struct cifs_sb_info *old =3D CIFS_SB(sb);
>>>> + =A0 =A0 struct cifs_sb_info *new =3D mnt_data->cifs_sb;
>>>> +
>>>> + =A0 =A0 if ((sb->s_flags & CIFS_MS_MASK) !=3D (mnt_data->flags &=
 CIFS_MS_MASK))
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>>>> +
>>>> + =A0 =A0 if ((old->mnt_cifs_flags & CIFS_MOUNT_MASK) !=3D
>>>> + =A0 =A0 =A0 =A0 (new->mnt_cifs_flags & CIFS_MOUNT_MASK))
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>>>> +
>>>> + =A0 =A0 if (old->rsize !=3D new->rsize)
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>>>> +
>>>> + =A0 =A0 if (new->wsize && new->wsize > old->wsize)
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>>>> +
>>>
>>> ...also I think the above condition should be reversed. We don't wa=
nt
>>> to match if new->wsize is smaller than the existing one. Since the
>>> specified wsize is just a starting point for negotiation, wsize now
>>> means "any wsize less than or equal to this size". If the old->wsiz=
e is
>>> bigger than that, then it's outside that range and we shouldn't mat=
ch.
>>
>> A more important question is whether the user intentionally tried to
>> specify a wsize. =A0I don't see a problem matching a new default mou=
nt
>> request (with no wsize specified, using therefore a default wsize)
>> with an existing mount (with a larger explicitly specified wsize).
>> If a user explicitly requests to override to a particular wsize on t=
he 2nd
>> mount - seems more logical to give them what they ask for if
>> possible whether larger or smaller.
>>
>
> If I understand right, Jeff suggested to change wsize logic to: "less
> or equal that specified one". In this case we can share any sb that
> match this criteria. So, in this case it should be "if (new->wsize &&
> new->wsize <=3D old->wsize) return 0;"

Sorry - new->wsize >=3D old->wsize
>
> --
> Best regards,
> Pavel Shilovsky.
>



--=20
Best regards,
Pavel Shilovsky.
