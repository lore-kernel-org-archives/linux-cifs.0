From: Koen Vermeer <koen-6aKAu+ryoJO2z7vLlVgmTQ@public.gmane.org>
Subject: Re: Map missing in cifs-mount, but available in smbclient
Date: Fri, 10 Jun 2011 20:40:39 +0200
Message-ID: <1307731239.3594.12.camel@green>
References: <loom.20110610T133205-66@post.gmane.org>
	 <BANLkTikey8w7Yf_A7hnRdXtN-p34N2U8AA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-FPreTiqKzPAeNGr5OOTo"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTikey8w7Yf_A7hnRdXtN-p34N2U8AA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


--=-FPreTiqKzPAeNGr5OOTo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi Steve,

Thanks for your reply. I managed to get the debug output (see
attachment), but not the wireshark trace. I can try to get that as well
if the problem cannot be diagnosed without it, but I'm a bit hesitant
given that this problem occurs on my computer at work.

My apologies for not mentioning the kernel version. I'm running
2.6.37-2-amd64 (Debian).

Thanks for any help!

Best,
Koen


On Fri, 2011-06-10 at 09:29 -0500, Steve French wrote:
> Any chance of a wireshark trace so we can see what the server returned?
> 
> http://wiki.samba.org/index.php/Capture_Packets
> 
> In addition turning on debugging before the problem, reproducing the
> problem, saving the dmesg log (see
> http://wiki.samba.org/index.php/LinuxCIFS_troubleshooting for
> instructions) would allow us to see if there are any errors.
> 
> Also would help to know the kernel version.
> 
> 
> 
> On Fri, Jun 10, 2011 at 6:39 AM, Koen Vermeer <koen-6aKAu+ryoJO2z7vLlVgmTQ@public.gmane.org> wrote:
> > Hi,
> >
> > I have mounted a share on a Windows-server with a corresponding entry in
> > /etc/fstab of:
> >
> > //san02-a/Data$ /mnt/san02-a/data       cifs
> > domain=MYDOMAIN,user=MYUSER,password=MYPASSWD,uid=MYUID,gid=MYGID,_netdev
> > 0       0
> >
> > This works reasonably well, except that I'm missing a folder. If I run 'ls
> > /mnt/san02-a/data/Afdeling/ROI/', I get two entries (PRIVATE and PUBLIC), but
> > one (STUDIES) is missing.
> >
> > Now, if I run
> >
> > smbclient -U MYNAME -W MYDOMAIN //san02-a/Data$
> >
> > and then do 'ls Afdeling\ROI\*', I do get all three directories. Changing to the
> > STUDIES directory also works fine.
> >
> > Can anyone give me a hint on how to fix this or how to find out what's going on?
> >
> > Best,
> > Koen
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> 


--=-FPreTiqKzPAeNGr5OOTo
Content-Disposition: attachment; filename="cifs.debug"
Content-Type: text/plain; name="cifs.debug"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[4441350.097011] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 187236869 with uid: 1000
[4441350.097019] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: Revalidate: \Projects inode 0xffff8800417a9bd0 count 1 dentry: 0xffff8800181240c0 d_time 5399470437 jiffies 5405229820
[4441350.097024] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: Getting info on \Projects
[4441350.097033] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/transport.c: For smb_command 50
[4441350.097036] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/transport.c: Sending smb:  total_len 96
[4441350.097576] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/connect.c: rfc1002 length 0xa2
[4441350.097589] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 281474976736982
[4441350.097593] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: cifs_revalidate_cache: inode 281474976736982 is unchanged
[4441350.097597] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: inode 0xffff8800417a9bd0 old_time=5405229070 new_time=5405229820
[4441350.097601] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 187236869) rc = 0
[4441350.097607] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 187236870 with uid: 1000
[4441350.097613] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: Revalidate: \Projects\PS Barry inode 0xffff88003fb70550 count 1 dentry: 0xffff8800b270e900 d_time 4796286124 jiffies 5405229820
[4441350.097616] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: Getting info on \Projects\PS Barry
[4441350.097620] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/transport.c: For smb_command 50
[4441350.097623] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/transport.c: Sending smb:  total_len 114
[4441350.098000] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/connect.c: rfc1002 length 0xb4
[4441350.098019] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 3377699720623018
[4441350.098023] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: cifs_revalidate_cache: inode 3377699720623018 is unchanged
[4441350.098026] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: inode 0xffff88003fb70550 old_time=5405229070 new_time=5405229820
[4441350.098030] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 187236870) rc = 0
[4441350.098036] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 187236871 with uid: 1000
[4441350.098041] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: Revalidate: \Projects\PS Barry\matlab inode 0xffff880002971bd0 count 1 dentry: 0xffff88000f7cb180 d_time 4096 jiffies 5405229820
[4441350.098045] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: Getting info on \Projects\PS Barry\matlab
[4441350.098049] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/transport.c: For smb_command 50
[4441350.098052] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/transport.c: Sending smb:  total_len 128
[4441350.098408] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/connect.c: rfc1002 length 0xc2
[4441350.098419] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 281474976845954
[4441350.098423] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: cifs_revalidate_cache: inode 281474976845954 is unchanged
[4441350.098426] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: inode 0xffff880002971bd0 old_time=5405229070 new_time=5405229820
[4441350.098431] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 187236871) rc = 0
[4441350.098486] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: CIFS VFS: in cifs_readdir as Xid: 187236872 with uid: 1000
[4441350.098491] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: Full path: \Projects\PS Barry\matlab start at: 0
[4441350.098494] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/cifssmb.c: In FindFirst for \Projects\PS Barry\matlab
[4441350.098500] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/transport.c: For smb_command 50
[4441350.098503] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/transport.c: Sending smb:  total_len 138
[4441350.098972] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/connect.c: rfc1002 length 0xf8
[4441350.098986] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: initiate cifs search rc 0
[4441350.098990] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: found entry - pos_in_buf 0
[4441350.098993] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: entry 2 found
[4441350.098996] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: loop through 2 times filling dir for net buf ffff880052a20000
[4441350.099000] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: new entry ffff880052a200a0 old entry ffff880052a20048
[4441350.099003] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: last entry in buf at pos 4 
[4441350.099006] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: CIFS VFS: leaving cifs_readdir (xid = 187236872) rc = 0
[4441350.099012] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: CIFS VFS: in cifs_readdir as Xid: 187236873 with uid: 1000
[4441350.099015] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: index not in buffer - could not findnext into it
[4441350.099018] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: could not find entry
[4441350.099021] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: CIFS VFS: leaving cifs_readdir (xid = 187236873) rc = 0
[4441350.099026] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/file.c: Closedir inode = 0xffff880002971bd0
[4441350.099030] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/file.c: CIFS VFS: in cifs_closedir as Xid: 187236874 with uid: 1000
[4441350.099033] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/file.c: Freeing private data in close dir
[4441350.099036] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/file.c: closedir free smb buf in srch struct
[4441350.099039] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/file.c: CIFS VFS: leaving cifs_closedir (xid = 187236874) rc = 0
[4441350.099085] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 187236875 with uid: 1000
[4441350.099088] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 187236875) rc = 0
[4441350.099092] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 187236876 with uid: 1000
[4441350.099096] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 187236876) rc = 0
[4441350.099100] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 187236877 with uid: 1000
[4441350.099104] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 187236877) rc = 0
[4441350.099116] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: CIFS VFS: in cifs_readdir as Xid: 187236878 with uid: 1000
[4441350.099120] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: Full path: \Projects\PS Barry\matlab start at: 0
[4441350.099123] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/cifssmb.c: In FindFirst for \Projects\PS Barry\matlab
[4441350.099127] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/transport.c: For smb_command 50
[4441350.099130] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/transport.c: Sending smb:  total_len 138
[4441350.099559] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/connect.c: rfc1002 length 0xf8
[4441350.099567] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: initiate cifs search rc 0
[4441350.099570] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: found entry - pos_in_buf 0
[4441350.099573] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: entry 2 found
[4441350.099576] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: loop through 2 times filling dir for net buf ffff880052a20000
[4441350.099580] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: new entry ffff880052a200a0 old entry ffff880052a20048
[4441350.099583] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: last entry in buf at pos 4 
[4441350.099586] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: CIFS VFS: leaving cifs_readdir (xid = 187236878) rc = 0
[4441350.099591] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: CIFS VFS: in cifs_readdir as Xid: 187236879 with uid: 1000
[4441350.099594] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: index not in buffer - could not findnext into it
[4441350.099597] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: could not find entry
[4441350.099600] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: CIFS VFS: leaving cifs_readdir (xid = 187236879) rc = 0
[4441350.099604] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/file.c: Closedir inode = 0xffff880002971bd0
[4441350.099608] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/file.c: CIFS VFS: in cifs_closedir as Xid: 187236880 with uid: 1000
[4441350.099611] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/file.c: Freeing private data in close dir
[4441350.099613] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/file.c: closedir free smb buf in srch struct
[4441350.099617] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/file.c: CIFS VFS: leaving cifs_closedir (xid = 187236880) rc = 0
[4441352.539814] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 187236881 with uid: 0
[4441352.539821] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: Revalidate: \Afdeling inode 0xffff8800938fafd0 count 1 dentry: 0xffff880060c27240 d_time 5405174545 jiffies 5405230430
[4441352.539826] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: Getting info on \Afdeling
[4441352.539834] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/transport.c: For smb_command 50
[4441352.539838] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/transport.c: Sending smb:  total_len 96
[4441352.540234] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/connect.c: rfc1002 length 0x9c
[4441352.540240] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/misc.c: Calculated size 154 vs length 156 mismatch for mid 37804
[4441352.540251] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 20269960
[4441352.540254] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: cifs_revalidate_cache: inode 20269960 is unchanged
[4441352.540258] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: inode 0xffff8800938fafd0 old_time=5405196623 new_time=5405230431
[4441352.540262] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 187236881) rc = 0
[4441352.540267] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 187236882 with uid: 0
[4441352.540272] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: Revalidate: \Afdeling\ROI inode 0xffff8800938fb250 count 1 dentry: 0xffff880060c27300 d_time 5405174545 jiffies 5405230431
[4441352.540276] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: Getting info on \Afdeling\ROI
[4441352.540280] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/transport.c: For smb_command 50
[4441352.540283] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/transport.c: Sending smb:  total_len 104
[4441352.540593] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/connect.c: rfc1002 length 0xa4
[4441352.540601] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/misc.c: Calculated size 162 vs length 164 mismatch for mid 37805
[4441352.540613] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 20269961
[4441352.540617] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: cifs_revalidate_cache: inode 20269961 is unchanged
[4441352.540621] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: inode 0xffff8800938fb250 old_time=5405196623 new_time=5405230431
[4441352.540625] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 187236882) rc = 0
[4441352.540629] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 187236883 with uid: 0
[4441352.540633] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 187236883) rc = 0
[4441352.540660] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 187236884 with uid: 0
[4441352.540664] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 187236884) rc = 0
[4441352.540668] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 187236885 with uid: 0
[4441352.540672] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 187236885) rc = 0
[4441352.540683] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: CIFS VFS: in cifs_readdir as Xid: 187236886 with uid: 0
[4441352.540687] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: Full path: \Afdeling\ROI start at: 0
[4441352.540691] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/cifssmb.c: In FindFirst for \Afdeling\ROI
[4441352.540695] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/transport.c: For smb_command 50
[4441352.540697] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/transport.c: Sending smb:  total_len 114
[4441352.541082] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/connect.c: rfc1002 length 0x174
[4441352.541098] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: initiate cifs search rc 0
[4441352.541103] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: found entry - pos_in_buf 0
[4441352.541108] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: entry 2 found
[4441352.541112] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: loop through 4 times filling dir for net buf ffff8800cbcc8000
[4441352.541118] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: new entry ffff8800cbcc808c old entry ffff8800cbcc8048
[4441352.541123] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: new entry ffff8800cbcc80d4 old entry ffff8800cbcc808c
[4441352.541129] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: For PRIVATE
[4441352.541135] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: new entry ffff8800cbcc8124 old entry ffff8800cbcc80d4
[4441352.541140] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: For PUBLIC
[4441352.541145] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: last entry in buf at pos 6 PUBLIC
[4441352.541150] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: CIFS VFS: leaving cifs_readdir (xid = 187236886) rc = 0
[4441352.541159] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: CIFS VFS: in cifs_readdir as Xid: 187236887 with uid: 0
[4441352.541164] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: index not in buffer - could not findnext into it
[4441352.541168] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: could not find entry
[4441352.541173] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: CIFS VFS: leaving cifs_readdir (xid = 187236887) rc = 0
[4441352.541181] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/file.c: Closedir inode = 0xffff8800938fb250
[4441352.541186] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/file.c: CIFS VFS: in cifs_closedir as Xid: 187236888 with uid: 0
[4441352.541190] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/file.c: Freeing private data in close dir
[4441352.541195] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/file.c: closedir free smb buf in srch struct
[4441352.541200] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/file.c: CIFS VFS: leaving cifs_closedir (xid = 187236888) rc = 0
[4441353.118119] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 187236889 with uid: 1000
[4441353.118130] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: Revalidate: \Projects inode 0xffff8800417a9bd0 count 1 dentry: 0xffff8800181240c0 d_time 5399470437 jiffies 5405230575
[4441353.118136] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: Getting info on \Projects
[4441353.118147] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/transport.c: For smb_command 50
[4441353.118151] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/transport.c: Sending smb:  total_len 96
[4441353.118687] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/connect.c: rfc1002 length 0xa2
[4441353.118704] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 281474976736982
[4441353.118709] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: cifs_revalidate_cache: inode 281474976736982 is unchanged
[4441353.118715] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: inode 0xffff8800417a9bd0 old_time=5405229820 new_time=5405230575
[4441353.118721] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 187236889) rc = 0
[4441353.118728] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 187236890 with uid: 1000
[4441353.118736] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: Revalidate: \Projects\PS Barry inode 0xffff88003fb70550 count 1 dentry: 0xffff8800b270e900 d_time 4796286124 jiffies 5405230575
[4441353.118742] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: Getting info on \Projects\PS Barry
[4441353.118748] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/transport.c: For smb_command 50
[4441353.118752] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/transport.c: Sending smb:  total_len 114
[4441353.119101] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/connect.c: rfc1002 length 0xb4
[4441353.119114] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 3377699720623018
[4441353.119120] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: cifs_revalidate_cache: inode 3377699720623018 is unchanged
[4441353.119125] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: inode 0xffff88003fb70550 old_time=5405229820 new_time=5405230575
[4441353.119131] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 187236890) rc = 0
[4441353.119139] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 187236891 with uid: 1000
[4441353.119146] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: Revalidate: \Projects\PS Barry\matlab inode 0xffff880002971bd0 count 1 dentry: 0xffff88000f7cb180 d_time 4096 jiffies 5405230575
[4441353.119152] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: Getting info on \Projects\PS Barry\matlab
[4441353.119158] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/transport.c: For smb_command 50
[4441353.119162] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/transport.c: Sending smb:  total_len 128
[4441353.119540] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/connect.c: rfc1002 length 0xc2
[4441353.119558] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 281474976845954
[4441353.119564] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: cifs_revalidate_cache: inode 281474976845954 is unchanged
[4441353.119569] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: inode 0xffff880002971bd0 old_time=5405229820 new_time=5405230575
[4441353.119575] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 187236891) rc = 0
[4441353.119621] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: CIFS VFS: in cifs_readdir as Xid: 187236892 with uid: 1000
[4441353.119628] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: Full path: \Projects\PS Barry\matlab start at: 0
[4441353.119633] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/cifssmb.c: In FindFirst for \Projects\PS Barry\matlab
[4441353.119639] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/transport.c: For smb_command 50
[4441353.119643] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/transport.c: Sending smb:  total_len 138
[4441353.120073] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/connect.c: rfc1002 length 0xf8
[4441353.120089] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: initiate cifs search rc 0
[4441353.120095] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: found entry - pos_in_buf 0
[4441353.120101] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: entry 2 found
[4441353.120107] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: loop through 2 times filling dir for net buf ffff880052a78000
[4441353.120114] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: new entry ffff880052a780a0 old entry ffff880052a78048
[4441353.120119] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: last entry in buf at pos 4 
[4441353.120126] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: CIFS VFS: leaving cifs_readdir (xid = 187236892) rc = 0
[4441353.120134] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: CIFS VFS: in cifs_readdir as Xid: 187236893 with uid: 1000
[4441353.120140] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: index not in buffer - could not findnext into it
[4441353.120146] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: could not find entry
[4441353.120151] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: CIFS VFS: leaving cifs_readdir (xid = 187236893) rc = 0
[4441353.120159] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/file.c: Closedir inode = 0xffff880002971bd0
[4441353.120165] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/file.c: CIFS VFS: in cifs_closedir as Xid: 187236894 with uid: 1000
[4441353.120171] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/file.c: Freeing private data in close dir
[4441353.120176] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/file.c: closedir free smb buf in srch struct
[4441353.120182] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/file.c: CIFS VFS: leaving cifs_closedir (xid = 187236894) rc = 0
[4441353.120224] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 187236895 with uid: 1000
[4441353.120231] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 187236895) rc = 0
[4441353.120238] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 187236896 with uid: 1000
[4441353.120244] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 187236896) rc = 0
[4441353.120252] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 187236897 with uid: 1000
[4441353.120258] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 187236897) rc = 0
[4441353.120275] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: CIFS VFS: in cifs_readdir as Xid: 187236898 with uid: 1000
[4441353.120282] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: Full path: \Projects\PS Barry\matlab start at: 0
[4441353.120287] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/cifssmb.c: In FindFirst for \Projects\PS Barry\matlab
[4441353.120294] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/transport.c: For smb_command 50
[4441353.120299] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/transport.c: Sending smb:  total_len 138
[4441353.120872] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/connect.c: rfc1002 length 0xf8
[4441353.120888] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: initiate cifs search rc 0
[4441353.120893] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: found entry - pos_in_buf 0
[4441353.120898] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: entry 2 found
[4441353.120903] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: loop through 2 times filling dir for net buf ffff880052a78000
[4441353.120909] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: new entry ffff880052a780a0 old entry ffff880052a78048
[4441353.120915] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: last entry in buf at pos 4 
[4441353.120922] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: CIFS VFS: leaving cifs_readdir (xid = 187236898) rc = 0
[4441353.120931] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: CIFS VFS: in cifs_readdir as Xid: 187236899 with uid: 1000
[4441353.120936] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: index not in buffer - could not findnext into it
[4441353.120942] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: could not find entry
[4441353.120948] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/readdir.c: CIFS VFS: leaving cifs_readdir (xid = 187236899) rc = 0
[4441353.120955] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/file.c: Closedir inode = 0xffff880002971bd0
[4441353.120961] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/file.c: CIFS VFS: in cifs_closedir as Xid: 187236900 with uid: 1000
[4441353.120967] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/file.c: Freeing private data in close dir
[4441353.120972] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/file.c: closedir free smb buf in srch struct
[4441353.120979] /build/buildd-linux-2.6_2.6.37-2-amd64-bITS0h/linux-2.6-2.6.37/debian/build/source_amd64_none/fs/cifs/file.c: CIFS VFS: leaving cifs_closedir (xid = 187236900) rc = 0

--=-FPreTiqKzPAeNGr5OOTo--
