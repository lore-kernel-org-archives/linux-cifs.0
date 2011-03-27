From: Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
Subject: Re: [PATCH] allow cifs passwords with utf8 characters
Date: Sun, 27 Mar 2011 09:54:38 +0200
Message-ID: <20110327075438.GA7174@osk.mine.nu>
References: <20110327070144.GA3772@osk.mine.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110327070144.GA3772-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sunday, March 27, 2011 at 09:44, Oskar Liljeblad wrote:
> I noticed that I could not mount cifs shares when the password contained
> utf8-encoded latin1 characters. (But somehow it worked when those latin1
> characters were encoded with ISO-8859-1.) So I made some modifications to
> assume utf8 passwords rather than raw 8-bit.
[..]
> +		len = utf8s_to_ucs2(passwd, 128, (wchar_t *) wpwd);

Looking at the code again, I wonder if not cifs_strtoUCS in cifs_unicode.c
should've been used instead?

  int
  cifs_strtoUCS(__le16 *to, const char *from, int len,
              const struct nls_table *codepage)

(I suspect people don't look so happily on exporting more symbols either
(utf8s_to_ucs2).)

The problem with cifs_strtoUCS is the codepage parameter though. Can one
assume that the "iocharset" codepage is used for the password as well?

Regards,

Oskar
