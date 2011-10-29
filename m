From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [patch] CIFS: double unlock in cifs_lock_add_if()
Date: Sat, 29 Oct 2011 11:25:06 +0400
Message-ID: <CAKywueR8r4f0w_KLqpJEExjnCDNt+XvzjHsc7qkx78qEXWDnpA@mail.gmail.com>
References: <20111029071854.GA17780@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111029071854.GA17780-mgFCXtclrQlZLf2FXnZxJA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/10/29 Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>:
> We unlocked "cinode->lock_mutex" twice so I've removed the first
> unlock.
>
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index ea096ce..b8dbab8 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -775,11 +775,9 @@ try_again:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0(lock->blist.next =3D=3D &lock->blist));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto try_again;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_lock(&cinode->loc=
k_mutex);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del_init(&lock->bl=
ist);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&cinode->l=
ock_mutex);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_lock(&cinode->lock_mutex);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del_init(&lock->blist);
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0kfree(lock);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

I recently posted the similar fix "CIFS: Remove extra mutex_unlock in
cifs_lock_add_if":
https://git.samba.org/sfrench/?p=3Dsfrench/cifs-2.6.git;a=3Dcommitdiff;=
h=3Dd12799b4c3c4d1e65d7fdbb5d91538c92d6863dd;hp=3Df362f98e7c445643d27c6=
10bb7a86b79727b592e

Anyway, thanks for catching this!

--=20
Best regards,
Pavel Shilovsky.
