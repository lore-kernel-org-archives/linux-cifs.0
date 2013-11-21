From: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Subject: Re: copy chunk preliminary results
Date: Thu, 21 Nov 2013 11:45:41 +0100
Message-ID: <20131121114541.09f67b3f@plati.site>
References: <CAH2r5mtoGCn-z_-Aetwaxxvn8bS19mexb7Rur3TE=RGipGCppQ@mail.gmail.com>
	<527771DA.1050701@draigBrady.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: =?UTF-8?B?UMOhZHJhaWc=?= Brady <P@draigBrady.com>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <527771DA.1050701-V8g9lnOeT5ydJdNcDFJN0w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 04 Nov 2013 10:07:22 +0000
P=C3=A1draig Brady <P@draigBrady.com> wrote:

> So cp --reflink has CoW semantics and so probably not an
> appropriate interface for this.  Unless I'm misunderstanding,
> this SMB copy offload does result in a normal copy on the server righ=
t?

It depends on how the SMB server interprets the copy-chunk wire request=
=2E
On Btrfs, Samba can translate the request into a BTRFS_IOC_CLONE_RANGE
ioctl, in which case the same CoW semantics are observed[1]. See:

https://wiki.samba.org/index.php/Server-Side_Copy#Btrfs_Enhanced_Server=
-Side_Copy_Offload

By default however, Samba (and Windows) will perform the copy on the
server-side using regular reads/writes. A generic cp --offload or
similar would probably make more sense on the client side.

Cheers, David
