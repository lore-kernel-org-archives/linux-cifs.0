From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: remove unused SMB2 config and mount options
Date: Mon, 23 May 2011 13:14:47 -0500
Message-ID: <BANLkTimUzjUURi_v8nc4Vb6kqu+NBT+yhA@mail.gmail.com>
References: <20110522110451.GA14262@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110522110451.GA14262-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, May 22, 2011 at 6:04 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> There's no SMB2 support in the CIFS filesystem driver, so there's no need to
> have a config and mount option for it.
>
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Merged.

Pavel noted that he now has a script to add/reenable the smb2 config
option and that he is ok with readding the small smb2 specific hits to
the common cifs code later when the new smb2 files are
reviewed/complete.    It complicates the preparatory cifs cleanup
slightly but is ok.

-- 
Thanks,

Steve
