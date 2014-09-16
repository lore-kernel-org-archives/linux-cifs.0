From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: remove dead code
Date: Tue, 16 Sep 2014 13:45:45 -0500
Message-ID: <CAH2r5mtvXinOSP7MujqLjdOggTnO4SrcO4WaA-iB7h=982XmSA@mail.gmail.com>
References: <3319326.1eJrmz0Vgc@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	Yalin Wang <yalin.wang-/MT0OVThwyLZJqsBc5GL+g@public.gmane.org>
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3319326.1eJrmz0Vgc@wuerfel>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged into cifs-2.6.git for-next

Added Yalin Wang <yalin.wang-/MT0OVThwyLZJqsBc5GL+g@public.gmane.org> who reported the same problem/fix

On Mon, Sep 8, 2014 at 10:20 AM, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:
> cifs provides two dummy functions 'sess_auth_lanman' and
> 'sess_auth_kerberos' for the case in which the respective
> features are not defined. However, the caller is also under
> an #ifdef, so we just get warnings about unused code:
>
> fs/cifs/sess.c:1109:1: warning: 'sess_auth_kerberos' defined but not used [-Wunused-function]
>  sess_auth_kerberos(struct sess_data *sess_data)
>
> Removing the dead functions gets rid of the warnings without
> any downsides that I can see.
>
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
>
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 07fe97ac6b0c..ab0fda6e8e58 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -745,14 +745,6 @@ out:
>         sess_free_buffer(sess_data);
>  }
>
> -#else
> -
> -static void
> -sess_auth_lanman(struct sess_data *sess_data)
> -{
> -       sess_data->result = -EOPNOTSUPP;
> -       sess_data->func = NULL;
> -}
>  #endif
>
>  static void
> @@ -1103,15 +1095,6 @@ out:
>         ses->auth_key.response = NULL;
>  }
>
> -#else
> -
> -static void
> -sess_auth_kerberos(struct sess_data *sess_data)
> -{
> -       cifs_dbg(VFS, "Kerberos negotiated but upcall support disabled!\n");
> -       sess_data->result = -ENOSYS;
> -       sess_data->func = NULL;
> -}
>  #endif /* ! CONFIG_CIFS_UPCALL */
>
>  /*
>



-- 
Thanks,

Steve
