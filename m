From: Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>
Subject: Re: [PATCH] fs: cifs: cifsencrypt.c: Cleaning up missing
 null-terminate in conjunction with strncpy
Date: Sun, 3 Aug 2014 01:13:25 +0200
Message-ID: <CAFo99gZrTd5+Z_XK+CmhF8ROPZSLGZvwzuwQSwFz5_kGHTAn8w@mail.gmail.com>
References: <1406413711-7798-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <CADT32eLts-tdQdHo+W3Zc1wQ6Qz8aS3TmHsm8OxmiF2fmhOW5g@mail.gmail.com> <1407000807.1835.14.camel@joe-AO725>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1407000807.1835.14.camel@joe-AO725>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2014-08-02 19:33 GMT+02:00 Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>:
> On Sat, 2014-08-02 at 11:55 -0500, Shirish Pargaonkar wrote:
>> Acked-by: Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>
> []
>> > diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> []
>> > @@ -307,7 +307,7 @@ int calc_lanman_hash(const char *password, const char *cryptkey, bool encrypt,
>> >
>> >         memset(password_with_pad, 0, CIFS_ENCPWD_SIZE);
>> >         if (password)
>> > -               strncpy(password_with_pad, password, CIFS_ENCPWD_SIZE);
>> > +               strncpy(password_with_pad, password, CIFS_ENCPWD_SIZE - 1);
>
>
> Is this always correct?


Hi

Because password_with_pad gets set to all zeros above, the character,
I do not guarantee a copy terminating null.
Unless it is so that you do not want any terminating null.


Kind regards
Rickard Strandqvist
