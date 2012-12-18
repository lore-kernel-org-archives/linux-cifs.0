From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH] cifs: Do not enable debugging code by default
Date: Tue, 18 Dec 2012 15:44:52 +0100
Message-ID: <20121218144452.GB31255@liondog.tnic>
References: <1355737085-6671-1-git-send-email-bp@alien8.de>
 <CAH2r5mt=4ZoGR_4hP52uHsZabXpPfh1sa1X0GSg6W4=fawNFnA@mail.gmail.com>
 <20121218071317.01cbc41b@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121218071317.01cbc41b-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Dec 18, 2012 at 07:13:17AM -0500, Jeff Layton wrote:
> I agree that we often need cifsFYI debug info in order to troubleshoot
> problems. The question here though is whether compiling those in ought
> to be the default.
>
> In generic distro kernels, I think we do want that turned on even in
> non-debug kernels. On an embedded arch, it's less compelling.
>
> Might it make sense to couple this change with a change to the
> CONFIG_CIFS_DEBUG help text? Something like:
>
> "This option defaults to 'N', but enabling this is strongly encouraged
> unless memory is severely constrained."

... or we make it default n if EMBEDDED, otherwise default y + changing
the help text?

> Then we can just try to make sure non-embedded distros enable it.

Yeah, I don't think distros look at the help text... or?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
