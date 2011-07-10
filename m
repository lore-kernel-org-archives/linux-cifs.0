From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: warning on rmmod cifs on current rc6
Date: Sun, 10 Jul 2011 13:46:52 -0500
Message-ID: <CAH2r5muEW4fJFQ2qPtkc4a8_+nwB_VEtj_xtm680qFbDnXdGng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Noticed the following warning on rmmod of cifs on most current
cifs-2.6.git (I have many of the kernel debugging menuconfig options
on). Ideas?

[13399.427527] kobject: 'cifs-1' (ffff8801410c3c00): kobject_uevent_env
[13399.427570] kobject: 'cifs-1' (ffff8801410c3c00): fill_kobj_path:
path = '/devices/virtual/bdi/cifs-1'
[13399.427652] kobject: 'cifs-1' (ffff8801410c3c00): kobject_cleanup
[13399.427658] kobject: 'cifs-1' (ffff8801410c3c00): calling ktype release
[13399.427673] kobject: 'cifs-1': free name
[13403.168585] FS-Cache: Netfs 'cifs' unregistered from caching
[13403.480203] kobject: 'cifs_inode_cache' (ffff8801303b30f8):
kobject_uevent_env
[13403.480245] kobject: 'cifs_inode_cache' (ffff8801303b30f8):
fill_kobj_path: path = '/kernel/slab/cifs_inode_cache'
[13403.480495] kobject: 'cifs_inode_cache' (ffff8801303b30f8): kobject_cleanup
[13403.480502] kobject: 'cifs_inode_cache' (ffff8801303b30f8): calling
ktype release
[13403.480514] kobject: 'cifs_inode_cache': free name
[13403.480572] kobject: 'cifs_mpx_ids' (ffff88013019d518): kobject_uevent_env
[13403.480608] kobject: 'cifs_mpx_ids' (ffff88013019d518):
fill_kobj_path: path = '/kernel/slab/cifs_mpx_ids'
[13403.480810] kobject: 'cifs_mpx_ids' (ffff88013019d518): kobject_cleanup
[13403.480816] kobject: 'cifs_mpx_ids' (ffff88013019d518): calling ktype release
[13403.480827] kobject: 'cifs_mpx_ids': free name
[13403.481450] kobject: 'cifs_request' (ffff88013019da40): kobject_uevent_env
[13403.481485] kobject: 'cifs_request' (ffff88013019da40):
fill_kobj_path: path = '/kernel/slab/cifs_request'
[13403.481674] kobject: 'cifs_request' (ffff88013019da40): kobject_cleanup
[13403.481680] kobject: 'cifs_request' (ffff88013019da40): calling ktype release
[13403.481689] kobject: 'cifs_request': free name
[13403.481941] kobject: 'cifs_small_rq' (ffff88013019d410): kobject_uevent_env
[13403.481977] kobject: 'cifs_small_rq' (ffff88013019d410):
fill_kobj_path: path = '/kernel/slab/cifs_small_rq'
[13403.482180] kobject: 'cifs_small_rq' (ffff88013019d410): kobject_cleanup
[13403.482186] kobject: 'cifs_small_rq' (ffff88013019d410): calling
ktype release
[13403.482196] kobject: 'cifs_small_rq': free name
[13403.485052] kobject: 'holders' (ffff880131bd2cc0): kobject_cleanup
[13403.485060] kobject: 'holders' (ffff880131bd2cc0): auto cleanup kobject_del
[13403.485075] kobject: 'holders' (ffff880131bd2cc0): calling ktype release
[13403.485081] kobject: (ffff880131bd2cc0): dynamic_kobj_release
[13403.485090] kobject: 'holders': free name
[13403.485105] kobject: 'notes' (ffff8801539dc088): kobject_cleanup
[13403.485110] kobject: 'notes' (ffff8801539dc088): auto cleanup kobject_del
[13403.485126] kobject: 'notes' (ffff8801539dc088): calling ktype release
[13403.485132] kobject: (ffff8801539dc088): dynamic_kobj_release
[13403.485141] kobject: 'notes': free name
[13403.485298] kobject: 'cifs' (ffffffffa04829f0): kobject_cleanup
[13403.485304] kobject: 'cifs' (ffffffffa04829f0): does not have a
release() function, it is broken and must be fixed.
[13403.485311] kobject: 'cifs' (ffffffffa04829f0): auto cleanup 'remove' event
[13403.485317] kobject: 'cifs' (ffffffffa04829f0): kobject_uevent_env
[13403.485352] kobject: 'cifs' (ffffffffa04829f0): fill_kobj_path:
path = '/module/cifs'
[13403.485404] kobject: 'cifs' (ffffffffa04829f0): auto cleanup kobject_del
[13403.485583] kobject: 'cifs': free name


-- 
Thanks,

Steve
