From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: smb2 work status
Date: Wed, 20 Jul 2011 18:19:14 +0400
Message-ID: <CAKywueSqO5g1M0Nt_ugPHZBbR=Siev0O5HVVvC0Lcj=9zvgtdA@mail.gmail.com>
References: <CAKywueQqyi6ynwoAv6Q3GzbxYJSOv7k229N3NA_y05kguqA+DQ@mail.gmail.com>
	<CAKywueRiuj=DrumdGMvdWX6ih8PVz4L0BL7G=LNL6CO+cEfmTQ@mail.gmail.com>
	<20110716192811.GE26925@infradead.org>
	<CAKywueSP7p3pja6FociCPXDtcSuChDdHw1JqCwxyhnqMuP5ahg@mail.gmail.com>
	<20110718154730.GA5822@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110718154730.GA5822-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I updated my branch smb2-dev (with the last changes. I moved to the
idea like you suggested (to keep separate calls for inode and file
operations) and organized the code with callbacks in some places
(cifs_iovec_read, cifs_iovec_write and cifs_reopen_file) that lets us
share the code between both protocols.

Next I am going to rethink cifs_get_inode_info according to this model
too and start to work on buffered i/o file operations. Also, I still
have not fix code style in earlier patches - going to do it too.

-- 
Best regards,
Pavel Shilovsky.
