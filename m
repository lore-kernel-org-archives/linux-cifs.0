From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2.6.36-rc7] cifs: cancel_delayed_work() +
 flush_scheduled_work() -> cancel_delayed_work_sync()
Date: Tue, 19 Oct 2010 13:22:56 -0500
Message-ID: <AANLkTi=mxgr2v3n8ZQYNtcBqK78LRUE6nF5Y20=VQDjz@mail.gmail.com>
References: <4CBDBF8A.8010106@kernel.org>
	<20101019121319.16f06b76@corrin.poochiereds.net>
	<4CBDC419.8060909@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CBDC419.8060909-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

OK - will add this to the cifs tree this afternoon.

On Tue, Oct 19, 2010 at 11:15 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello,
>
> On 10/19/2010 06:13 PM, Jeff Layton wrote:
>> On Tue, 19 Oct 2010 17:55:54 +0200
>> Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>
>>> flush_scheduled_work() is going away.
>>>
>>> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>> ---
>>> =A0fs/cifs/cifs_dfs_ref.c | =A0 =A03 +--
>>> =A01 file changed, 1 insertion(+), 2 deletions(-)
>>>
>>> Index: work/fs/cifs/cifs_dfs_ref.c
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>> --- work.orig/fs/cifs/cifs_dfs_ref.c
>>> +++ work/fs/cifs/cifs_dfs_ref.c
>>> @@ -44,8 +44,7 @@ static void cifs_dfs_expire_automounts(s
>>> =A0void cifs_dfs_release_automount_timer(void)
>>> =A0{
>>> =A0 =A0 =A0BUG_ON(!list_empty(&cifs_dfs_automount_list));
>>> - =A0 =A0cancel_delayed_work(&cifs_dfs_automount_task);
>>> - =A0 =A0flush_scheduled_work();
>>> + =A0 =A0cancel_delayed_work_sync(&cifs_dfs_automount_task);
>>> =A0}
>>>
>>> =A0/**
>>
>> Looks like a better way to do this anyhow.
>>
>> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> Yeah, way faster too. =A0It would be best to route this patch through
> cifs tree but I can push it through wq tree too. =A0Just let me know.
>
> Thanks.
>
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
