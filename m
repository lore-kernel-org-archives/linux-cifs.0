From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: CIFS: Move set_file_size to ops struct
Date: Mon, 22 Jul 2013 09:59:39 +0300
Message-ID: <20130722065939.GE14617@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Pavel,

I had a question about cifs_set_file_size().

The patch d143341815bd: "CIFS: Move set_file_size to ops struct" from
Sep 18, 2012, leads to the following warning:
"fs/cifs/inode.c:1901 cifs_set_file_size()
	 warn: 'open_file' was already freed."

fs/cifs/inode.c
  1887          open_file = find_writable_file(cifsInode, true);
  1888          if (open_file) {
  1889                  tcon = tlink_tcon(open_file->tlink);
  1890                  server = tcon->ses->server;
  1891                  if (server->ops->set_file_size)
  1892                          rc = server->ops->set_file_size(xid, tcon, open_file,
  1893                                                          attrs->ia_size, false);
  1894                  else
  1895                          rc = -ENOSYS;
  1896                  cifsFileInfo_put(open_file);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^
Smatch is complaining that if open_file->count here is zero then it will
be freed.  I don't know if this is possible.  My concern is because
prior to that patch we used to read the netfid information in a separate
step before calling cifsFileInfo_put() so that we wouldn't use freed
memory.

  1897                  cifs_dbg(FYI, "SetFSize for attrs rc = %d\n", rc);
  1898                  if ((rc == -EINVAL) || (rc == -EOPNOTSUPP)) {
  1899                          unsigned int bytes_written;
  1900  
  1901                          io_parms.netfid = open_file->fid.netfid;
                                                  ^^^^^^^^^^^^^^^^^^^^^
Dereference.

  1902                          io_parms.pid = open_file->pid;

regards,
dan carpenter
