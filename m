From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix error handling when cifscreds key payload is an error
Date: Fri, 20 Jan 2012 13:44:07 -0600
Message-ID: <CAH2r5mtTtYzj5MJXc5pu3L+cKO1XKrrcx6=gr8W_874sYPzfnw@mail.gmail.com>
References: <1327064677-15896-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1327064677-15896-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Looks reasonable.  Was this found by static code analysis?

On Fri, Jan 20, 2012 at 7:04 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 986709a..aa687c8 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2125,7 +2125,7 @@ cifs_set_cifscreds(struct smb_vol *vol, struct =
cifs_ses *ses)
> =A0 =A0 =A0 =A0down_read(&key->sem);
> =A0 =A0 =A0 =A0upayload =3D key->payload.data;
> =A0 =A0 =A0 =A0if (IS_ERR_OR_NULL(upayload)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D PTR_ERR(key);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D upayload ? PTR_ERR(upayload) : -=
EINVAL;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_key_put;
> =A0 =A0 =A0 =A0}
>
> --
> 1.7.7.5
>



--=20
Thanks,

Steve
