From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [RFC v0 1/4] vfs: add copy_range syscall and vfs entry point
Date: Wed, 15 May 2013 14:54:29 -0400
Message-ID: <20130515185429.GA25994@fieldses.org>
References: <CAH2r5ms0P8Hgv1mUpyHA32Er38iiaC1HHC4fhxvz2SBFy6Sucw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, zab@redhat.com,
	linux-cifs@vger.kernel.org
To: Steve French <smfrench@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5ms0P8Hgv1mUpyHA32Er38iiaC1HHC4fhxvz2SBFy6Sucw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Wed, May 15, 2013 at 12:50:13PM -0500, Steve French wrote:
> Doesn't the new syscall have to invalidate the page cache pages that
> the server is about to overwrite as btrfs does with the following line
> in fs/btrfs/ioctl.c
> 
> 	truncate_inode_pages_range(&inode->i_data, destoff,
> 				   PAGE_CACHE_ALIGN(destoff + len) - 1);
> 
> (and doesn't truncate_inode_pages_range handle page cache alignment
> anyway - and also why did btrfs use truncate_inode_pages_range instead
> of invalidate?)
> 
> Does nfs client ever have the case where two different superblocks map
> to the same nfs export (and thus the check below is restricting the
> ability to do server side copy)?
> 
> +	if (inode_in->i_sb != inode_out->i_sb ||
> +	    file_in->f_path.mnt != file_out->f_path.mnt)
> +		return -EXDEV;

The client attempts to use the same superblock whenever it can.

I suppose you're also losing the opportunity to copy between two
different filesystems on the same server, which should be faster than
requiring the client to do the copy.

--b.

> 
> I am working on cifs client patches for the ioctl, and the new syscall
> also looks pretty easy.   Some popular cifs servers (like Windows)
> have supported smb/cifs copy offload for many, many years - and now
> Samba with the support that David Disseldorp added for the clone range
> ioctl has been supporting copychunk (server side copy from Windows to
> Samba) so about time to finish the cifs client equivalent.
> 
> -- 
> Thanks,
> 
> Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
