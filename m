From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: smb2 work status
Date: Tue, 19 Jul 2011 07:24:33 -0400
Message-ID: <20110719072433.7f9c1cd2@corrin.poochiereds.net>
References: <CAKywueQqyi6ynwoAv6Q3GzbxYJSOv7k229N3NA_y05kguqA+DQ@mail.gmail.com>
	<CAKywueRiuj=DrumdGMvdWX6ih8PVz4L0BL7G=LNL6CO+cEfmTQ@mail.gmail.com>
	<20110716192811.GE26925@infradead.org>
	<CAKywueSP7p3pja6FociCPXDtcSuChDdHw1JqCwxyhnqMuP5ahg@mail.gmail.com>
	<20110718154730.GA5822@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110718154730.GA5822-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 18 Jul 2011 11:47:30 -0400
Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> On Mon, Jul 18, 2011 at 07:45:01PM +0400, Pavel Shilovsky wrote:
> > If I understand you right, you mean to separate inode and file
> > operations for smb2 into a different structures, set them once with
> > ifdefs in cifs_set_ops() and keep them in smb2inode.c and smb2file.c
> > files.
> 
> That's the idea.  You'll really have to prototype it to check if it
> works out nicely.  If we end up duplicating too much it might not
> be feasible, but fro ma quick look it should be much better.
> 

Agreed. Once you mount, you know what protocol version you're using.
There's little value in continually checking that.

Another idea to consider would be to keep the same set of VFS ops, and
abstract out the lower level set of protocol operations. This is the
model that NFS uses for NFSv2 and 3. v4 is a bit different but it
does use the same file and inode ops for some things. See, for example,
nfs_v3_clientops.

Even if you do take Christoph's suggestion, I think there is value in
abstracting out the protocol operations as well. Better organization
like this will make the code less of a pain to maintain over the long
term.

There are also some things in this set that really ought to be
encapsulated into accessor routines. For example:

+       /* Don't want to modify the buffer as a side effect of this call. */
+       if (server->is_smb2 == false)
+               smb_buffer->smb_buf_length = cpu_to_be32(smb_buf_length);
+#ifdef CONFIG_CIFS_SMB2
+       else
+               smb2_buffer->smb2_buf_length = cpu_to_be32(smb_buf_length);
+#endif


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
