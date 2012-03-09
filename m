From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: use standard token parser for mount options
Date: Fri, 09 Mar 2012 11:16:13 -0500
Message-ID: <4F5A2CCD.6010808@gmail.com>
References: <1331307197.10670.2.camel@localhost> <CAFB9KM0AMO_r0W2grCk2MRfZ9bVf+J5pbP1Yexxw46dacoYynw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFB9KM0AMO_r0W2grCk2MRfZ9bVf+J5pbP1Yexxw46dacoYynw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 3/9/2012 10:57 AM, Scott Lovenberg wrote:
>
>
> On Fri, Mar 9, 2012 at 10:33, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org 
> <mailto:sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>> wrote:
>
>     Use the standard token parser instead of the long if confidtion to
>     parse
>     cifs mount options.
>
>     This was first proposed by Scott Lovenberg
>     http://lists.samba.org/archive/linux-cifs-client/2010-May/006079.html
>
>     Mount options have been grouped together in terms of their input
>     types.
>     Aliases for username, password, domain and credentials have been
>     added.
>     The password parser has been modified to make it easier to read.
>
>     Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
>     <mailto:sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>>
>
[CC'ing the list my response... kernel.org didn't like my HTML formatted 
email]
Thanks. :)  IIRC, Jeff was getting panics on a Fedora box using this 
patch.  I never got around to fixing it.  I'll still sign off on it though.
