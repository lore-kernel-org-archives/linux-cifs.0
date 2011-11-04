From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Patch numeric domain names
Date: Fri, 4 Nov 2011 09:52:53 -0400
Message-ID: <20111104095253.14e7f0a5@tlielax.poochiereds.net>
References: <005801cc9a9e$59d4f2a0$0d7ed7e0$@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "Donald R. Gray Jr" <donald.r.gray-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <005801cc9a9e$59d4f2a0$0d7ed7e0$@gmail.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 3 Nov 2011 23:03:36 -0400
"Donald R. Gray Jr" <donald.r.gray-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Patch to allow numbers in domain names for cifscreds. 

According to this msdn page, we should actually be able to allow more
characters than just alphanumerics in NetBIOS domain names:

    http://support.microsoft.com/kb/909264

Would it be better to fix the code to just follow those rules instead?


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
