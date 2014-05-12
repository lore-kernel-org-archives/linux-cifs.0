From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v2] cifs: call print_hex_dump instead of custom
 implementation
Date: Mon, 12 May 2014 19:15:09 +0300
Message-ID: <1399911309.3703.14.camel@smile.fi.intel.com>
References: <1399907720-18622-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20140512114247.0c96ad58@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, Alexander Bokovoy <ab@samba.org>, samba-technical@lists.samba.org
To: Jeff Layton <jlayton@poochiereds.net>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20140512114247.0c96ad58@tlielax.poochiereds.net>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Mon, 2014-05-12 at 11:42 -0400, Jeff Layton wrote:
> On Mon, 12 May 2014 18:15:20 +0300
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> 
> > This patch converts custom dumper to use native print_hex_dump() instead. The
> > dump will have a given label and addresses per each line which differs it from
> > the original code.
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> >  fs/cifs/cifs_debug.c | 21 ++-------------------
> >  1 file changed, 2 insertions(+), 19 deletions(-)
> > 
> > diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> > index fa78b68..e7b87ce 100644
> > --- a/fs/cifs/cifs_debug.c
> > +++ b/fs/cifs/cifs_debug.c
> > @@ -34,27 +34,10 @@
> >  void
> >  cifs_dump_mem(char *label, void *data, int length)
> >  {
> > -	int i, j;
> > -	int *intptr = data;
> > -	char *charptr = data;
> > -	char buf[10], line[80];
> > -
> >  	printk(KERN_DEBUG "%s: dump of %d bytes of data at 0x%p\n",
> >  		label, length, data);
> > -	for (i = 0; i < length; i += 16) {
> > -		line[0] = 0;
> > -		for (j = 0; (j < 4) && (i + j * 4 < length); j++) {
> > -			sprintf(buf, " %08x", intptr[i / 4 + j]);
> > -			strcat(line, buf);
> > -		}
> > -		buf[0] = ' ';
> > -		buf[2] = 0;
> > -		for (j = 0; (j < 16) && (i + j < length); j++) {
> > -			buf[1] = isprint(charptr[i + j]) ? charptr[i + j] : '.';
> > -			strcat(line, buf);
> > -		}
> > -		printk(KERN_DEBUG "%s\n", line);
> > -	}
> > +	print_hex_dump(KERN_DEBUG, label, DUMP_PREFIX_ADDRESS, 16, 4,
> > +		       data, length, true);
> 
> I'm not sure we want "label" as the prefix_str as it'll go on every
> line. Maybe just use "" in place of "label" there?

It was in my initial v1. I thought it would be better to have.
What about addresses? Would you like to see it or offset is enough, or
drop them as well?

Moreover, I found another place where similar change could be done
(dump_smb), so, would it be better to do in separate patch?

> 
> >  }
> >  
> >  #ifdef CONFIG_CIFS_DEBUG
> 
> Otherwise, this looks good.
> 
> Acked-by: Jeff Layton <jlayton@poochiereds.net>


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy
