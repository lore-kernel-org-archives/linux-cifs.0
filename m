From: Richard Genoud <richard.genoud-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: =?UTF-8?Q?Re=3A_=5BPATCH=5D_cifssmb=3A_=5BFIX=5D_warning=3A_=E2=80=98pdata=E2=80=99_may_?=
	=?UTF-8?Q?be_used_uninitialized?=
Date: Sun, 13 Mar 2011 23:45:17 +0100
Message-ID: <AANLkTikJVqk7UO6Be1A12SRp62z0h7rjEdhUa-uMYH2t@mail.gmail.com>
References: <1300033426-22404-1-git-send-email-richard.genoud@gmail.com> <AANLkTiko9Y6z79XwkxN7dEAyikQbO=Azdiu0hhK+uiJc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTiko9Y6z79XwkxN7dEAyikQbO=Azdiu0hhK+uiJc-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/3/13 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> This does look a problem with the compiler. =C2=A0Which compiler vers=
ion?
>
> As you noted, pdata is either initialized or we return rc!=3D0 and do=
n't use it.
>
The compiler is gcc from ubuntu 10.10 :
gcc (Ubuntu/Linaro 4.4.4-14ubuntu5) 4.4.5
