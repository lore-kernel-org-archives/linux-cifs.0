From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs/dir.c: use correct path separator
Date: Wed, 07 Sep 2016 10:27:06 +0100
Message-ID: <1473240426.3882.42.camel@redhat.com>
References: <mps60q8sy4z.fsf@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
To: =?ISO-8859-1?Q?Aur=E9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <mps60q8sy4z.fsf-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2016-09-06 at 20:04 +0200, Aurélien Aptel wrote:
> Current code hardcodes the path separator to backslash. The loop
> after
> it that switches the slashes direction only operates on the dfs
> prefix,
> not the whole path. Use CIFS_DIR_SEP instead.
> 
Hello Aurélien,

Can you please add this summary to the patch summary and repost the
patch using git send-email instead. Having the patch inline makes it a
bit easier to review the patch.

Sachin Prabhu
