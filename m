From: Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>
Subject: Regression in 4.14-rc: CIFS SMB2+ combined with pythons
 xattr.listxattr leads to "IOError: [Errno 61] No data available"
Date: Tue, 26 Sep 2017 18:54:08 +0200
Message-ID: <4d13dddc-2df2-4112-a214-15700c22ed50@leemhuis.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-MW
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Lo! Since updating to 4.14-rc my backup program rdiff-backup (written in
python) crashes with an error when it tries to create a backup on a
SMB2+ share mounted with CIFS (not sure which SMB version it is
exactly). I assume this started to happen due to the xattr support for
smb2+ that got merged in 8dc5b3a6cb2f (didn't find time to check a
revert yet). It still happens with rc2, so the fixes that got merged to
mainline at the end of last week didn't help.

Find the error output from rdiff-backup at the end of the mail. I did a
few tests and saw the following on 4.14-rc2;  /mnt/tests/ is the share I
backup to.

"""
 >>> import xattr
 >>> xattr.listxattr('/mnt/tests/')
 Traceback (most recent call last):
   File "<stdin>", line 1, in <module>
 IOError: [Errno 61] No data available>>>
"""

When I mount that share with "-o vers=1.0" the command works just fine:

"""
 >>> import xattr
 >>> xattr.listxattr('/mnt/tests/')
 []
 >>>
"""

FWIW, on 4.13.3 a SMB2+ mount of the share fails like this:

"""
 >>> import xattr
 >>> xattr.listxattr('/mnt/tests')
 Traceback (most recent call last):
   File "<stdin>", line 1, in <module>
 IOError: [Errno 95] Operation not supported>>>
"""
But it seems rdiff-backup can catch and handle this error just fine.

What to do about this? Ciao, Thorsten

P.S.: here is the complete error output from rdiff-backup:

> Found interrupted initial backup. Removing...
> Exception '[Errno 61] No data available' raised of class '<type 'exceptions.IOError'>':
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/Main.py", line 304, in error_check_Main
>     try: Main(arglist)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/Main.py", line 324, in Main
>     take_action(rps)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/Main.py", line 280, in take_action
>     elif action == "backup": Backup(rps[0], rps[1])
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/Main.py", line 334, in Backup
>     rpout.conn.fs_abilities.backup_set_globals(rpin, force)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/fs_abilities.py", line 936, in backup_set_globals
>     update_quoting = bsg.set_chars_to_quote(Globals.rbdir, force)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/fs_abilities.py", line 734, in set_chars_to_quote
>     self.get_ctq_from_fsas(), force)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/fs_abilities.py", line 765, in compare_ctq_file
>     ctq_rp.write_string(actual_ctq)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/rpath.py", line 1206, in write_string
>     self.setdata()
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/rpath.py", line 909, in setdata
>     if self.lstat(): self.conn.rpath.setdata_local(self)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/rpath.py", line 1496, in setdata_local
>     if Globals.eas_conn: rpath.data['ea'] = ea_get(rpath)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/eas_acls.py", line 597, in rpath_ea_get
>     ea.read_from_rp(rp)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/eas_acls.py", line 60, in read_from_rp
>     attr_list = rp.conn.xattr.listxattr(rp.path, rp.issym())
> 
> Traceback (most recent call last):
>   File "/usr/bin/rdiff-backup", line 30, in <module>
>     rdiff_backup.Main.error_check_Main(sys.argv[1:])
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/Main.py", line 304, in error_check_Main
>     try: Main(arglist)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/Main.py", line 324, in Main
>     take_action(rps)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/Main.py", line 280, in take_action
>     elif action == "backup": Backup(rps[0], rps[1])
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/Main.py", line 334, in Backup
>     rpout.conn.fs_abilities.backup_set_globals(rpin, force)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/fs_abilities.py", line 936, in backup_set_globals
>     update_quoting = bsg.set_chars_to_quote(Globals.rbdir, force)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/fs_abilities.py", line 734, in set_chars_to_quote
>     self.get_ctq_from_fsas(), force)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/fs_abilities.py", line 765, in compare_ctq_file
>     ctq_rp.write_string(actual_ctq)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/rpath.py", line 1206, in write_string
>     self.setdata()
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/rpath.py", line 909, in setdata
>     if self.lstat(): self.conn.rpath.setdata_local(self)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/rpath.py", line 1496, in setdata_local
>     if Globals.eas_conn: rpath.data['ea'] = ea_get(rpath)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/eas_acls.py", line 597, in rpath_ea_get
>     ea.read_from_rp(rp)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/eas_acls.py", line 60, in read_from_rp
>     attr_list = rp.conn.xattr.listxattr(rp.path, rp.issym())
> IOError: [Errno 61] No data availableFound interrupted initial backup. Removing...
> Exception '[Errno 61] No data available' raised of class '<type 'exceptions.IOError'>':
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/Main.py", line 304, in error_check_Main
>     try: Main(arglist)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/Main.py", line 324, in Main
>     take_action(rps)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/Main.py", line 280, in take_action
>     elif action == "backup": Backup(rps[0], rps[1])
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/Main.py", line 334, in Backup
>     rpout.conn.fs_abilities.backup_set_globals(rpin, force)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/fs_abilities.py", line 936, in backup_set_globals
>     update_quoting = bsg.set_chars_to_quote(Globals.rbdir, force)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/fs_abilities.py", line 734, in set_chars_to_quote
>     self.get_ctq_from_fsas(), force)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/fs_abilities.py", line 765, in compare_ctq_file
>     ctq_rp.write_string(actual_ctq)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/rpath.py", line 1206, in write_string
>     self.setdata()
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/rpath.py", line 909, in setdata
>     if self.lstat(): self.conn.rpath.setdata_local(self)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/rpath.py", line 1496, in setdata_local
>     if Globals.eas_conn: rpath.data['ea'] = ea_get(rpath)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/eas_acls.py", line 597, in rpath_ea_get
>     ea.read_from_rp(rp)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/eas_acls.py", line 60, in read_from_rp
>     attr_list = rp.conn.xattr.listxattr(rp.path, rp.issym())
> 
> Traceback (most recent call last):
>   File "/usr/bin/rdiff-backup", line 30, in <module>
>     rdiff_backup.Main.error_check_Main(sys.argv[1:])
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/Main.py", line 304, in error_check_Main
>     try: Main(arglist)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/Main.py", line 324, in Main
>     take_action(rps)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/Main.py", line 280, in take_action
>     elif action == "backup": Backup(rps[0], rps[1])
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/Main.py", line 334, in Backup
>     rpout.conn.fs_abilities.backup_set_globals(rpin, force)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/fs_abilities.py", line 936, in backup_set_globals
>     update_quoting = bsg.set_chars_to_quote(Globals.rbdir, force)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/fs_abilities.py", line 734, in set_chars_to_quote
>     self.get_ctq_from_fsas(), force)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/fs_abilities.py", line 765, in compare_ctq_file
>     ctq_rp.write_string(actual_ctq)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/rpath.py", line 1206, in write_string
>     self.setdata()
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/rpath.py", line 909, in setdata
>     if self.lstat(): self.conn.rpath.setdata_local(self)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/rpath.py", line 1496, in setdata_local
>     if Globals.eas_conn: rpath.data['ea'] = ea_get(rpath)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/eas_acls.py", line 597, in rpath_ea_get
>     ea.read_from_rp(rp)
>   File "/usr/lib64/python2.7/site-packages/rdiff_backup/eas_acls.py", line 60, in read_from_rp
>     attr_list = rp.conn.xattr.listxattr(rp.path, rp.issym())
