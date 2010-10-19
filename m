From: Jeff Layton <jlayton@samba.org>
Subject: Re: linux-next: build warning after merge of the cifs tree
Date: Tue, 19 Oct 2010 09:13:39 -0400
Message-ID: <20101019091339.38e45faa@tlielax.poochiereds.net>
References: <20100924135531.96e5ac72.sfr@canb.auug.org.au>
	<20101019162120.76e03b4b.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench@gmail.com>, <linux-cifs@vger.kernel.org>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Shirish Pargaonkar <shirishpargaonkar@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20101019162120.76e03b4b.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Tue, 19 Oct 2010 16:21:20 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Steve,
> 
> On Fri, 24 Sep 2010 13:55:31 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > After merging the irqflags tree, today's linux-next build (powerpc
> > ppc64_defconfig) produced this warning:
> > 
> > fs/cifs/sess.c: In function 'CIFS_SessSetup':
> > fs/cifs/sess.c:595: warning: unused variable 'blob_len'
> > 
> > Introduced by commit 15f6bdfb9914b0c41848f874719911ba053be931 ("cifs
> > NTLMv2/NTLMSSP ntlmv2 within ntlmssp autentication code").
> > CONFIG_CIFS_UPCALL is not set in this build.
> 
> I am still getting this ...
> 

Yep. Looks clearly broken. blob_len is also declared twice in that
function which is just plain wrong. What probably makes the most sense
is to make it a u16 and get rid of the second declaration lower in the
function. But, there's another semi-related problem here too...

blob_len gets assigned the return value of build_ntlmssp_auth_blob.
That function however doesn't have any mechanism to pass back an
error, even though it calls setup_ntlmv2_rsp and that function can
return one.

The whole house of cards needs a bit of rework I think...

Shirish, since you're already doing work in this area, can you fix that
too?

Thanks,
-- 
Jeff Layton <jlayton@samba.org>
