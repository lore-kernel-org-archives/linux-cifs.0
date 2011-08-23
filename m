From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 0/5] cifs-utils: cifsacl utilities: Implement getcifsacl
 and setcifsacl
Date: Tue, 23 Aug 2011 08:58:39 -0400
Message-ID: <20110823085839.41396116@corrin.poochiereds.net>
References: <1313810832-2245-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1313810832-2245-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 19 Aug 2011 22:27:12 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> 
> Implement utilities getcifsacl and setcifsacl
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Set of patches to build utilities getcifsacl and setcifsacl
> along with their manpages.
> 
> getcifsacl fetches a security descriptor of a file off of a
> share mounted using option cifsacl using API getxattr.
> It then parses the security descriptor printing control
> porttion of the security descriptor and then DACL if there
> is one by printing each ACE with it fields, SID, type, flags, and mask.
> 
> setcifsacl builds two lists of ACEs, one specified on the command line
> and other fetched from the file the way getcifacl does.
> It then constructs a security descriptor consisting of ACL
> and uses API setxattr to send the security descriptor as a blob to
> the server.  setcifsacl also works with files off of shares
> mounted with option cifsacl.
> 
> manpages are provided for both the utilities with some examples
> in setcifsacl manpage.  The usage of getcifsacl is simple and
> very much self explanatory.
>  
> With these utilities, there is a way to interprete and construct a
> blob describing security descritpor of a file system object.
> 
> These utilities are modeled after smbcacls command in the
> Samba suite.
> 

Other than my comments on the header and the autoconf stuff, I think
this is probably OK. I do wonder whether time would be better spent on
getting RichACL's into the VFS, but this certainly doesn't preclude
that, and seems useful.

One minor nit: you should add the manpages before the autoconf changes
to make sure that bisectability is preserved.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
