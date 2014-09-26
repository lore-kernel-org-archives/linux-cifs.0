From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Fix problem recognizing symlinks
Date: Fri, 26 Sep 2014 08:14:52 -0700
Message-ID: <CAH2r5muZaof_a3ZJVOYnXgdDJByicb6P7dcOSFy6LW_7fxA9sQ@mail.gmail.com>
References: <20140926150615.GA11817@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140926150615.GA11817@mwanda>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

That is already fixed in cifs-2.6.git for-next

On Fri, Sep 26, 2014 at 8:06 AM, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> Hello Steve French,
>
> The patch 2b20ac4fcd7b: "Fix problem recognizing symlinks" from Sep
> 25, 2014, leads to the following static checker warning:
>
>         fs/cifs/smb1ops.c:589 cifs_query_path_info()
>         warn: we tested 'rc' before and it was 'false'
>
> fs/cifs/smb1ops.c
>    569
>    570          if (!rc && (le32_to_cpu(data->Attributes) & ATTR_REPARSE)) {
>                     ^^^
>
>    571                  int tmprc;
>    572                  int oplock = 0;
>    573                  struct cifs_fid fid;
>    574                  struct cifs_open_parms oparms;
>    575
>    576                  oparms.tcon = tcon;
>    577                  oparms.cifs_sb = cifs_sb;
>    578                  oparms.desired_access = FILE_READ_ATTRIBUTES;
>    579                  oparms.create_options = 0;
>    580                  oparms.disposition = FILE_OPEN;
>    581                  oparms.path = full_path;
>    582                  oparms.fid = &fid;
>    583                  oparms.reconnect = false;
>    584
>    585                  /* Need to check if this is a symbolic link or not */
>    586                  tmprc = CIFS_open(xid, &oparms, &oplock, NULL);
>    587                  if (tmprc == -EOPNOTSUPP)
>    588                          *symlink = true;
>    589                  else if (rc == 0)
>                                  ^^^^^^^
> The patch adds this new always true condition.  It's not clear what the
> intent was.
>
>    590                          CIFSSMBClose(xid, tcon, fid.netfid);
>    591          }
>
> regards,
> dan carpenter



-- 
Thanks,

Steve
