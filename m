From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: serverino by default?
Date: Tue, 17 May 2011 15:15:26 -0500
Message-ID: <BANLkTinQfEsjUkEZRzZHd7ZcjbQAci9crg@mail.gmail.com>
References: <BANLkTimDt8oOdzD9LpJAu4OyA6g8vOafrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTimDt8oOdzD9LpJAu4OyA6g8vOafrg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We clearly want to use server inode numbers where possible but this
was tricky until some fixes were made last year (which checked for
duplicate inode numbers and collisions e.g.)

On Tue, May 17, 2011 at 2:54 PM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =
wrote:
> In mount.cifs.8 page we have: "Client generates inode numbers (rather
> than using the actual one from the server) by default", but if we loo=
k
> at the code we can see that
> we use server's numbers by default instead:
>
> http://git.kernel.org/?p=3Dlinux/kernel/git/sfrench/cifs-2.6.git;a=3D=
blob;f=3Dfs/cifs/connect.c;h=3D277262a8e82f282d4a32b0ddd4a244bc55e99472=
;hb=3D221d1d797202984cb874e3ed9f1388593d34ee22#l859
>
> So, where is a error?
>
> --
> Best regards,
> Pavel Shilovsky.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
