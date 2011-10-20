From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs: Assume passwords are encoded according to
 iocharset (try #2)
Date: Thu, 20 Oct 2011 15:13:00 -0400
Message-ID: <20111020151300.5fd507ba@tlielax.poochiereds.net>
References: <1319134919-4300-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319134919-4300-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 20 Oct 2011 13:21:59 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Re-posting a patch originally posted by Oskar Liljeblad after
> rebasing on 3.2.
> 
> 
> Modify cifs to assume that the supplied password is encoded according
> to iocharset.  Before this patch passwords would be treated as
> raw 8-bit data, which made authentication with Unicode passwords impossible
> (at least passwords with characters > 0xFF).
> 
> The previous code would as a side effect accept passwords encoded with
> ISO 8859-1, since Unicode < 0x100 basically is ISO 8859-1.  Software which
> relies on that will no longer support password chars > 0x7F unless it also
> uses iocharset=iso8859-1.  (mount.cifs does not care about the encoding so
> it will work as expected.)
> 
> Signed-off-by: Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Tested-by: A <nimbus1_03087-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>


I don't know about this. What happens if I have characters in my
password that are not part of the current iocharset? I guess I'm
screwed?

The iocharset (and on smbfs, the remotenls) really only referred to the
encoding/decoding of filenames. What's the justification for assuming
that the password ought to be governed by that as well?

If you're mounting with a cred file, is it really correct to assume
that it's encoded according to the local charset? It seems like if I
have the password stored in a credential file that it ought to work
even if I copy it to a host that uses a different iocharset for
encoding and decoding filenames.

Would it be better to have userspace encode the password instead so
that you have some flexibility if it's impossible to encode your
password in the current iocharset?

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
