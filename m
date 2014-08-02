From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] fs: cifs: cifsencrypt.c: Cleaning up missing
 null-terminate in conjunction with strncpy
Date: Sat, 02 Aug 2014 10:33:27 -0700
Message-ID: <1407000807.1835.14.camel@joe-AO725>
References: <1406413711-7798-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	 <CADT32eLts-tdQdHo+W3Zc1wQ6Qz8aS3TmHsm8OxmiF2fmhOW5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Steve French <sfrench@samba.org>,
	linux-cifs <linux-cifs@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CADT32eLts-tdQdHo+W3Zc1wQ6Qz8aS3TmHsm8OxmiF2fmhOW5g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Sat, 2014-08-02 at 11:55 -0500, Shirish Pargaonkar wrote:
> Acked-by: Shirish Pargaonkar <spargaonkar@suse.com>
[]
> > diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
[]
> > @@ -307,7 +307,7 @@ int calc_lanman_hash(const char *password, const char *cryptkey, bool encrypt,
> >
> >         memset(password_with_pad, 0, CIFS_ENCPWD_SIZE);
> >         if (password)
> > -               strncpy(password_with_pad, password, CIFS_ENCPWD_SIZE);
> > +               strncpy(password_with_pad, password, CIFS_ENCPWD_SIZE - 1);


Is this always correct?
