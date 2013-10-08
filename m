From: Steve French <smfrench@gmail.com>
Subject: Re: [[PATCH v2] [CIFS] Allow setting per-file compression via SMB2
 and SMB3
Date: Tue, 8 Oct 2013 17:53:35 -0500
Message-ID: <CAH2r5mtLYhRxRegVZNZJ1n=7dXizTGd+GTPT2tHjSfeKf=HngA@mail.gmail.com>
References: <CAH2r5mubgNp_gY=0b_dWuQx2X2S1hESz5iKXwNhGZfXwCM7TsA@mail.gmail.com>
	<20131009002545.114ae8a5@plati.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>
To: David Disseldorp <ddiss@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20131009002545.114ae8a5@plati.site>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Tue, Oct 8, 2013 at 5:25 PM, David Disseldorp <ddiss@suse.de> wrote:
> Hi Steve,
>
> On Tue, 8 Oct 2013 15:41:17 -0500
> Steve French <smfrench@gmail.com> wrote:
>
>> +                     /* Currently only flag we can set is compressed flag */
>> +                     if ((ExtAttrBits & FS_COMPR_FL) == 0)
>> +                             break;
>> +
>> +                     /* Try to set compress flag */
>> +                     if (tcon->ses->server->ops->set_compression) {
>> +                             rc = tcon->ses->server->ops->set_compression(
>> +                                                     xid, tcon, pSMBFile);
>> +                             cifs_dbg(FYI, "set compress flag rc %d\n", rc);
>>                       }
>
> Is the FileFsAttributeInformation known at this stage? If so, you may

During mount we do:

        if (!tcon->ipc && server->ops->qfs_tcon)
                server->ops->qfs_tcon(xid, tcon);

(for informational/debug purposes) but qfs_tcon is only defined in
cifs, not for smb2/smb2.1/smb3.  We could add it easily enough (so you
could see this info in /proc/fs/cifs/ or perhaps /proc/mounts if that
were preferred - but in any case added SMB2 QFS Attribute Info would
probably be better as a distinct patch).


> wish to check for the FILE_FILE_COMPRESSION capability, and avoid the
> request dispatch if absent.

There doesn't seem to be much harm in sending the set compression
fsctl so we know the most uptodate info on whether the server can
support it or not - since this is an explicit command at cli (not in
the Linux GUIs AFAIK - although if there were a way to advertise
per-mount capabilities this would be a logical one to add)

> IIRC, Explorer hides the compression check-checkbox if the capability
> is missing.

I am a little worried about two cases:

1) what if the server reenabled compression on the underlying volume
after we mounted the share

2) what if the server exports multiple file systems under a single
share one which supports compression and one which doesn't - we would
only query on the root


-- 
Thanks,

Steve
