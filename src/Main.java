import java.io.InputStream;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.Properties;
import java.util.concurrent.CountDownLatch;

public class Main {

    public static void main(String[] args) throws InterruptedException {
        clear();
        show();
        new CountDownLatch(1).await();
    }

    private static void clear() {
        System.out.print("\u001b[2J\u001b[3J\u001b[H");
        System.out.flush();
    }

    private static void show() {
        Properties config = new Properties();

        try (InputStream in = Main.class.getResourceAsStream("/config.properties")) {
            if (in == null) {
                System.out.println("config.properties not found in the jar.");
                return;
            }
            config.load(in);
        } catch (Exception e) {
            System.out.println("Could not read config.properties: " + e.getMessage());
            return;
        }

        String url = config.getProperty("url", "").trim();
        if (url.isEmpty()) {
            System.out.println("No URL was configured.");
            return;
        }

        try {
            HttpClient client = HttpClient.newBuilder()
                    .followRedirects(HttpClient.Redirect.NORMAL)
                    .build();

            HttpRequest request = HttpRequest.newBuilder(URI.create(url)).GET().build();
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));

            if (response.statusCode() == 200) {
                System.out.print(response.body());
            } else {
                System.out.println("Server returned HTTP " + response.statusCode());
            }
        } catch (Exception e) {
            System.out.println("Download failed: " + e.getMessage());
        }

        System.out.flush();
    }
}
