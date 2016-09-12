From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs_get_root shouldn't use path with tree name
Date: Mon, 12 Sep 2016 17:40:09 +0100
Message-ID: <1473698409.29354.3.camel@redhat.com>
References: <1473260003-5271-1-git-send-email-sprabhu@redhat.com>
         <mpsmvjir7hx.fsf@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
To: =?ISO-8859-1?Q?Aur=E9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <mpsmvjir7hx.fsf-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 2016-09-08 at 12:49 +0200, Aurélien Aptel wrote:
> Hi Sachin,
> 
> As you said, patch is similar to what I proposed few month ago.
> There's
> only one thing that bothers me. cifs_build_path_to_root() has this
> bit
> before the DFS test:
> 
> 	/* if no prefix path, simply set path to the root of share to
> "" */
> 	if (pplen == 0) {
> 		full_path = kzalloc(1, GFP_KERNEL);
> 		return full_path;
> 	}
> 
> 
> I think it should be dropped. It was already inconsistent because if
> the
> share was in a DFS without a prepath it would have returned an empty
> string instead of a path with the tree name prefix.
> 
> I can send a patch after yours to correct that you think it should be
> in
> a separate commit.
> 
> Cheers,
> 

I suspect that is because the root of the share cannot be a DFS mount.
Maybe Steve can confirm it. 

Sachin Prabhu
