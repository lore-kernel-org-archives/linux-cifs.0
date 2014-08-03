From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] fs: cifs: cifsencrypt.c: Cleaning up missing
 null-terminate in conjunction with strncpy
Date: Sat, 02 Aug 2014 17:27:46 -0700
Message-ID: <1407025666.1835.16.camel@joe-AO725>
References: <1406413711-7798-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <CADT32eLts-tdQdHo+W3Zc1wQ6Qz8aS3TmHsm8OxmiF2fmhOW5g@mail.gmail.com>
	<1407000807.1835.14.camel@joe-AO725> <CAFo99gZrTd5+Z_XK+CmhF8ROPZSLGZvwzuwQSwFz5_kGHTAn8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench@samba.org>, linux-cifs <linux-cifs@vger.kernel.org>, samba-technical <samba-technical@lists.samba.org>, LKML <linux-kernel@vger.kernel.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <CAFo99gZrTd5+Z_XK+CmhF8ROPZSLGZvwzuwQSwFz5_kGHTAn8w@mail.gmail.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Sun, 2014-08-03 at 01:13 +0200, Rickard Strandqvist wrote:
> 2014-08-02 19:33 GMT+02:00 Joe Perches <joe@perches.com>:
> > On Sat, 2014-08-02 at 11:55 -0500, Shirish Pargaonkar wrote:
> >> Acked-by: Shirish Pargaonkar <spargaonkar@suse.com>
> > []
> >> > diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> > []
> >> > @@ -307,7 +307,7 @@ int calc_lanman_hash(const char *password, const char *cryptkey, bool encrypt,
> >> >
> >> >         memset(password_with_pad, 0, CIFS_ENCPWD_SIZE);
> >> >         if (password)
> >> > -               strncpy(password_with_pad, password, CIFS_ENCPWD_SIZE);
> >> > +               strncpy(password_with_pad, password, CIFS_ENCPWD_SIZE - 1);
> >
> >
> > Is this always correct?
[]
> Because password_with_pad gets set to all zeros above, the character,
> I do not guarantee a copy terminating null.
> Unless it is so that you do not want any terminating null.

That's the question for Steve and cifs people.
