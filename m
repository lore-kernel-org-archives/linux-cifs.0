From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: unneeded mutex in cifs_fsync
Date: Fri, 28 Oct 2011 16:18:18 -0500
Message-ID: <CAH2r5mvn+G-K3W4opPFXyLfoa3-Xxrmq0nBC8wPsDZzeu5m7ZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Is this mutex really needed in cifs_fsync? (It got moved down from the vfs
with a global change to the vfs fsync for btrfs in
02c24a82187d5a628c68edfe71ae60dc135cd178). Don't see a problem with
sending multiple flushes in parallel on the wire.

        mutex_lock(&inode->i_mutex);

        xid = GetXid();

        cFYI(1, "Sync file - name: %s datasync: 0x%x",
                file->f_path.dentry->d_name.name, datasync);

        tcon = tlink_tcon(smbfile->tlink);
        if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
                rc = CIFSSMBFlush(xid, tcon, smbfile->netfid);

        FreeXid(xid);
        mutex_unlock(&inode->i_mutex);


-- 
Thanks,

Steve
