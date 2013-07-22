From: Joe Perches <joe@perches.com>
Subject: Re: Recvfile patch used for Samba.
Date: Mon, 22 Jul 2013 16:26:20 -0700
Message-ID: <1374535580.2061.85.camel@joe-AO722>
References: <20130722215738.GB20647@samba2>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench@gmail.com>, Jeff Layton <jlayton@samba.org>,
	linux-cifs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Jeremy Allison <jra@samba.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20130722215738.GB20647@samba2>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Mon, 2013-07-22 at 14:57 -0700, Jeremy Allison wrote:
> Here is a patch that Samba vendors have been using
> to implement recvfile (copy directly from socket
> to file). It can improve write performance on boxes
> by a significant amount (10% or more).
> 
> I'm not qualified to evaluate this code,

Nor I really.  This doesn't apply to current btw.

Single comment: (just on a brief look)

do_splice_from_socket with 64bit compilation appears
to have a pretty large (~1500 byte) stack frame which
doesn't seem very nice.  maybe a malloc/free instead
of stack for 
	struct recvfile_ctl_blk rv_cb[MAX_PAGES_PER_RECVFILE];
	struct kvec iov[MAX_PAGES_PER_RECVFILE];


