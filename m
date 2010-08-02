From: Jon Bramley <brammers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Problems with CVS on CIFS since kernel 2.6.30
Date: Mon, 2 Aug 2010 16:08:59 +0100
Message-ID: <AANLkTin9uwwDaw+nvAiDKnPxPbbBXycVS3rLvhCaoJxQ@mail.gmail.com>
References: <AANLkTingdjU-KKW3=KboAnR0pNeiE7aEje0nXhM6bYbe@mail.gmail.com>
	<4C56DBDD.4070501@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C56DBDD.4070501-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Suresh,

Firstly, thanks for responding.

> See options serverino, noserverino and section inode numbers in 'man
> mount.cifs' for additional information regarding this error.

I've read the man pages and understand that noserverino will break
hardlinks, but it doesn't work with or without this option.

> Is there a hardlink involved?

No.

> The samba version you are using seem to be quite old.. Does better POSIX
> support/conformance sound like a good enough reason..?

I doubt it. The problem I have is that it is working fine for Ubuntu
users (which is the vast majority) so they will not want to risk
breaking things. Of course that means I cannot currently update my
kernel (which they are less concerned about).

>> strange thing, is that some of my colleagues run Ubuntu 10.04, which
>> uses the 2.6.32 kernel, and they can use the share without problem.

> What is the server version in this case?

Exactly the same server that I'm connecting to (3.0.28a).

Thanks,

Jon
