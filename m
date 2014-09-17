From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH v4 2/3] cifs: convert to print_hex_dump() instead of
 custom implementation
Date: Wed, 17 Sep 2014 14:07:44 -0500
Message-ID: <CAH2r5muAtFu9YT8etmTvoFs-SJpeANGLLUtdRQaoj3FN+yxozw@mail.gmail.com>
References: <1409147384-20389-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1409147384-20389-3-git-send-email-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <sfrench@samba.org>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, Alexander Bokovoy <ab@samba.org>,
	samba-technical <samba-technical@lists.samba.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <1409147384-20389-3-git-send-email-andriy.shevchenko@linux.intel.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

Do you have a sample for what the output change looks like?

On Wed, Aug 27, 2014 at 8:49 AM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> This patch converts custom dumper to use native print_hex_dump() instead. The
> cifs_dump_mem() will have an offsets per each line which differs it from the
> original code.
>
> In the dump_smb() we may use native print_hex_dump() as well. It will show
> slightly different output in ASCII part when character is unprintable,
> otherwise it keeps same structure.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  fs/cifs/cifs_debug.c | 21 ++-------------------
>  fs/cifs/misc.c       | 32 ++------------------------------
>  2 files changed, 4 insertions(+), 49 deletions(-)
>
> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> index 7c50bfa..14e082f 100644
> --- a/fs/cifs/cifs_debug.c
> +++ b/fs/cifs/cifs_debug.c
> @@ -34,27 +34,10 @@
>  void
>  cifs_dump_mem(char *label, void *data, int length)
>  {
> -       int i, j;
> -       int *intptr = data;
> -       char *charptr = data;
> -       char buf[10], line[80];
> -
>         printk(KERN_DEBUG "%s: dump of %d bytes of data at 0x%p\n",
>                 label, length, data);
> -       for (i = 0; i < length; i += 16) {
> -               line[0] = 0;
> -               for (j = 0; (j < 4) && (i + j * 4 < length); j++) {
> -                       sprintf(buf, " %08x", intptr[i / 4 + j]);
> -                       strcat(line, buf);
> -               }
> -               buf[0] = ' ';
> -               buf[2] = 0;
> -               for (j = 0; (j < 16) && (i + j < length); j++) {
> -                       buf[1] = isprint(charptr[i + j]) ? charptr[i + j] : '.';
> -                       strcat(line, buf);
> -               }
> -               printk(KERN_DEBUG "%s\n", line);
> -       }
> +       print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 4,
> +                      data, length, true);
>  }
>
>  #ifdef CONFIG_CIFS_DEBUG
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index b7415d5..3379463 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -513,39 +513,11 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
>  void
>  dump_smb(void *buf, int smb_buf_length)
>  {
> -       int i, j;
> -       char debug_line[17];
> -       unsigned char *buffer = buf;
> -
>         if (traceSMB == 0)
>                 return;
>
> -       for (i = 0, j = 0; i < smb_buf_length; i++, j++) {
> -               if (i % 8 == 0) {
> -                       /* have reached the beginning of line */
> -                       printk(KERN_DEBUG "| ");
> -                       j = 0;
> -               }
> -               printk("%0#4x ", buffer[i]);
> -               debug_line[2 * j] = ' ';
> -               if (isprint(buffer[i]))
> -                       debug_line[1 + (2 * j)] = buffer[i];
> -               else
> -                       debug_line[1 + (2 * j)] = '_';
> -
> -               if (i % 8 == 7) {
> -                       /* reached end of line, time to print ascii */
> -                       debug_line[16] = 0;
> -                       printk(" | %s\n", debug_line);
> -               }
> -       }
> -       for (; j < 8; j++) {
> -               printk("     ");
> -               debug_line[2 * j] = ' ';
> -               debug_line[1 + (2 * j)] = ' ';
> -       }
> -       printk(" | %s\n", debug_line);
> -       return;
> +       print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_NONE, 8, 2, buf,
> +                      smb_buf_length, true);
>  }
>
>  void
> --
> 2.1.0
>



-- 
Thanks,

Steve
