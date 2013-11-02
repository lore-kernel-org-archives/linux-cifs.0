From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix symbolic links usage
Date: Sat, 2 Nov 2013 23:42:24 +0400
Message-ID: <CAKywueTd9uUtPJS3X3aRQAtmpBOU-xO0SbbQP6s1gd=QcjATWQ@mail.gmail.com>
References: <1383314259-4694-1-git-send-email-piastryyy@gmail.com>
	<CADT32eKo3gQ06m1V3PZ64OdQp-iLw5VVnecZBO--T0pg9+CiBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Joao Correia <joaomiguelcorreia-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eKo3gQ06m1V3PZ64OdQp-iLw5VVnecZBO--T0pg9+CiBQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2013/11/1 Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Pavel, does this handle a case where it could be symbolic link
> to a directory?

Shirish, yes - it supports symbolic links to directories as well as to
files. It treats them both as Unix symbolic links without any
difference.

-- 
Best regards,
Pavel Shilovsky.
