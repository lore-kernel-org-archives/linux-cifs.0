From: David Disseldorp <ddiss@suse.de>
Subject: Re: cp --reflink and target file open flags
Date: Thu, 17 Oct 2013 12:45:15 +0200
Message-ID: <20131017124515.3566d7c1@plati.site>
References: <CAH2r5muRfQ6y1vzu_1icz4BGTqEPfgaOsHExbQay_yZiCOZQ_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAH2r5muRfQ6y1vzu_1icz4BGTqEPfgaOsHExbQay_yZiCOZQ_A@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Wed, 16 Oct 2013 18:36:19 -0500
Steve French <smfrench@gmail.com> wrote:

> cp --reflink opens the target file for O_WRONLY before invoking the
> (BTRFS) ioctl for clone file, but for copy offload over the network
> the SMB2 specification requires that the target file be open O_RDWR.
> 
> I may be able to upgrade the target file handle on the fly by
> reopening it in cifs.ko, and of course I can write an SMB2/SMB3
> specific copy command, but it would be preferable to allow use of cp
> --reflink since so many people are familiar with it.
> 
> There is quite a bit of flexibility in server side copy offload  -
> more than cp an offer, especially when using SMB3 or later dialects
> (e.g. in number of chunks sent at one time, chunk size, attributes
> copied, and even whether to use T10 style offload), but still it would
> be nice to support "cp --reflink" over the network.  Any ideas on
> this?
> 
> After looking at copy.c in coreutils for cp - I couldn't think of any
> trivial way to force cp to open the target RW.
> 
> Ideas?

You should be able to avoid this by using FSCTL_SRV_COPYCHUNK_WRITE
instead of FSCTL_SRV_COPYCHUNK on the wire. The former doesn't require
read access on the target, while the latter does. See [MS-SMB2] 2.2.31
and smbtorture's copy_chunk_bad_access test.

Samba only supported FSCTL_SRV_COPYCHUNK until now, as that's what
Windows Server 2k12 uses for copies initiated by Explorer. I've just
sent out the trivial patches adding FSCTL_SRV_COPYCHUNK_WRITE support.

Cheers, David
