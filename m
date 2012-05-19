From: Jeff Layton <jlayton@samba.org>
Subject: Re: Trouble with mount.cifs while smbclient works (Ubuntu
 12.04)
Date: Sat, 19 May 2012 08:37:49 -0400
Message-ID: <20120519083749.513816b0@tlielax.poochiereds.net>
References: <B284DF0EE72EBA488F6C7ED035128BF5105B547675@AUSX7MCPS302.AMER.DELL.COM>
	<CADT32e+HONu1ABEyjbgeLQjEBCzMjc01FTewJoHsT1bWn7tkTg@mail.gmail.com>
	<B284DF0EE72EBA488F6C7ED035128BF5105B4F777B@AUSX7MCPS302.AMER.DELL.COM>
	<201205180302.45016.linux@kukkukk.com>
	<B284DF0EE72EBA488F6C7ED035128BF5105B5B1C37@AUSX7MCPS302.AMER.DELL.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: samba@lists.samba.org, linux-cifs@vger.kernel.org
To: <Scott_Purcell@Dell.com>
Return-path: <samba-bounces@lists.samba.org>
In-Reply-To: <B284DF0EE72EBA488F6C7ED035128BF5105B5B1C37@AUSX7MCPS302.AMER.DELL.COM>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba>,
	<mailto:samba-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba>
List-Post: <mailto:samba@lists.samba.org>
List-Help: <mailto:samba-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba>,
	<mailto:samba-request@lists.samba.org?subject=subscribe>
Sender: samba-bounces@lists.samba.org
Errors-To: samba-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Fri, 18 May 2012 16:32:29 -0500
<Scott_Purcell@Dell.com> wrote:

> Yes, I think that has been the normal behavior since our data was moved to this device.  I assumed it was due to filesystem permissions -- that I don't have read access to the root level of the share, but do have r/w access to the /training/ directory below it.
> 
> Using smbclient, get "NT_STATUS_ACCESS_DENIED" when I try:
> 
> 	ls 
> 	ls training
> 	ls /training
> 	ls /training/
> 
> but if I cd to training, I can list its contents.
> 
> BTW, 
> 
> I've tried appending the path in my mount command as well and mount.cifs still doesn't handle it:
> 
> 

Known problem since the superblock sharing patches went in. cifs.ko
needs to establish a dentry and inode for the root of the share and
then walks down to the "prefixpath" for the mount. Unfortunately if you
don't have access to any point along that path, the mount will fail.

There have been a couple of proposals to fix it, but they've had their
own problems. What probably needs to happen is to do something like
what NFS does in its superblock sharing model. Allow several trees of
dentries within a superblock and only connect them later if we happen
to stumble across the right entry. See commit 54ceac45159 for an
explanation of the model NFS uses for this.

-- 
Jeff Layton <jlayton@samba.org>
-- 
To unsubscribe from this list go to the following URL and read the
instructions:  https://lists.samba.org/mailman/options/samba
