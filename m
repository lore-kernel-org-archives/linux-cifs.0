From: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] libmount: Special handling of root comparison for cifs
 in mnt_table_is_fs_mounted()
Date: Thu, 29 Sep 2016 11:55:53 +0200
Message-ID: <20160929095553.2f6g4b2mutotqi2r@ws.net.home>
References: <91d465d3-4f5b-6270-a6c5-38bd94695731@suse.cz>
 <5eb96b3e-d463-bf11-49de-f614247d6b29@suse.cz>
 <20160805192234.2c9d5b7d@aaptelpc>
 <7c2181d1-c7b5-df04-0640-ec23f5d78eab@suse.cz>
 <c4f10081-4525-4ac0-0e6b-b364c7268200@suse.cz>
 <eec8f575-eab2-34bb-882a-11fb8c33d9c0@suse.cz>
 <mpsbn06ruwv.fsf@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Stanislav Brabec <sbrabec-AlSwsSmVLrQ@public.gmane.org>,
        util-linux <util-linux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: =?iso-8859-1?Q?Aur=E9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <mpsbn06ruwv.fsf-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Sep 02, 2016 at 08:58:08PM +0200, Aurélien Aptel wrote:
> I'm attaching a simpler patch that makes uses of streq_paths() in
> lib/strutils.c (Note: streq_paths() and next_path_segment() have to be
> backported for older versions of util-linux).
> 
>
> From a29acba1a7c71cdbfc1cc98f2905bfaf19b97a29 Mon Sep 17 00:00:00 2001
> From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
> Date: Thu, 1 Sep 2016 13:57:42 +0200
> Subject: [PATCH] libmount/src/tab.c: fix mount -a for cifs

 Applied, thanks!

    Karel


-- 
 Karel Zak  <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 http://karelzak.blogspot.com
