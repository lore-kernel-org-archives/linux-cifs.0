From: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [cifs-utils PATCH] doc: convert pod files to rst
Date: Thu, 26 Oct 2017 14:21:42 -0400
Message-ID: <1509042102.29077.35.camel@kernel.org>
References: <20171025140002.5631-1-jlayton@kernel.org>
         <mps3765kfkq.fsf@aaptelpc.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: =?ISO-8859-1?Q?Aur=E9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <mps3765kfkq.fsf-zpEvHKhluMwYitT5tn2FcQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 2017-10-26 at 19:02 +0200, Aurélien Aptel wrote:
> Hi Jeff,
> 
> After reading this document
> 
>   http://docutils.sourceforge.net/docs/user/rst/quickref.html
> 
> I've made the following change:
> 
> - Use regular lists ("- xyz")
> - Replace the weird \ **xyz** \ to ``xyz`` when used for verbatim text
> - Added/removed newlines and fixed EOL whitespace
> - Used links for sections references ("`THE SECTION`_")
> - Use definition lists for parameters:
> 
>   foo=bar
>     desc desc
>     desc.
> 
>     desc desc.
> 
> I've already done mount.cifs.rst so far (attached). Feel free to use it
> in your patch.
> 
> PS: it's Aurélien (you can drop the é but please keep the last e :)
> 

Fixed the name in the changelog.

Many thanks for the extra cleanup there.

I'll squash that in with my patch. Do you mind if I add your Signed-off-
by to the patch as well?

Thanks,
-- 
Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
