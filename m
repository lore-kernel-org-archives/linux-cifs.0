From: Ross Lagerwall <ross.lagerwall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: Drop cached dentry if its metadata changed
Date: Tue, 20 Oct 2015 09:55:59 +0100
Message-ID: <5626019F.7020606@citrix.com>
References: <1445260986-1886-1-git-send-email-ross.lagerwall@citrix.com>
 <CAH2r5mvsfV07CGQj61hExObi9CJWvZEpQvuC5UjxHax80LNS7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvsfV07CGQj61hExObi9CJWvZEpQvuC5UjxHax80LNS7g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/19/2015 05:21 PM, Steve French wrote:
> Could you verify this over SMB2 (vers=3.0) as well?  It looks like it
> should fail because cifs_all_info_to_fattr doesn't see the inode
> attribute change and fill in the new inode number  (IndexNuber).  I am
> suspicious that your patch is overkill (sends an extra request on
> revalidate, doubling the traffic) in the SMB2/SMB3 case since we are
> already doing a query file with FILE_ALL_INFO requested which already
> returned IndexNumber (so should have already gotten the inode number)
> - probably more important to use the IndexNumber we got back rather
> than request it twice.

It was verified with vers=3.0. It works due to the following code, where 
-ESTALE is returned if uniqueid has changed (this is independent of 
cifs_all_info_to_fattr).


>> @@ -814,8 +814,26 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
>>                          }
>>                  } else
>>                          fattr.cf_uniqueid = iunique(sb, ROOT_I);
>> -       } else
>> -               fattr.cf_uniqueid = CIFS_I(*inode)->uniqueid;
>> +       } else {
>> +               if (check_inode_no &&
>> +                   (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) &&
>> +                   server->ops->get_srv_inum) {
>> +                       tmprc = server->ops->get_srv_inum(xid,
>> +                               tcon, cifs_sb, full_path,
>> +                               &fattr.cf_uniqueid, data);
>> +                       if (tmprc) {
>> +                               cifs_dbg(FYI, "GetSrvInodeNum rc %d\n",
>> +                                        tmprc);
>> +                               fattr.cf_uniqueid = iunique(sb, ROOT_I);
>> +                               cifs_autodisable_serverino(cifs_sb);
>> +                       } else if (CIFS_I(*inode)->uniqueid !=
>> +                                       fattr.cf_uniqueid) {
>> +                               rc = -ESTALE;
>> +                               goto cgii_exit;
>> +                       }
>> +               } else
>> +                       fattr.cf_uniqueid = CIFS_I(*inode)->uniqueid;
>> +       }
>>
>>          /* query for SFU type info if supported and needed */
>>          if (fattr.cf_cifsattrs & ATTR_SYSTEM &&

Maybe it is possible for cifs_all_info_to_fattr to update the inode 
number in place?

I'm a bit concerned with the approach above that it only applies when 
the dentry is revalidated. There are many other instances where 
cifs_get_inode_info is called and the inode number may have changed 
which this does not take care of.

I'm certainly not an expert in this area, so looking for ideas of how to 
solve the problem.

Thanks,
-- 
Ross Lagerwall
